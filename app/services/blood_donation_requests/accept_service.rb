# frozen_string_literal: true

module BloodDonationRequests
  class AcceptService
    attr_reader :blood_donation_request

    def initialize(blood_donation_request)
      @blood_donation_request = blood_donation_request
    end

    def call
      blood_request = blood_donation_request.blood_request

      blood_request.with_lock do
        validate_request_status!(blood_request)

        validate_donation_request!

        accept_current_request!

        update_blood_request!(blood_request)

        notify_blood_requester
      end

      blood_donation_request
    end

    private

    def validate_request_status!(blood_request)
      unless %w[open matched].include?(blood_request.status)
        raise StandardError,
              "Blood request is no longer accepting donors"
      end
    end

    def validate_donation_request!
      unless blood_donation_request.status == "pending"
        raise StandardError,
              "Donation request has already been processed"
      end
    end

    def accept_current_request!
      blood_donation_request.update!(
        status: "accepted"
      )
    end

    def update_blood_request!(blood_request)
      return unless blood_request.status == "open"

      blood_request.update!(
        status: "matched"
      )
    end

    def notify_blood_requester
      Notifications::CreateService.call(
        user: blood_donation_request.blood_request.user,
        title: "Blood Donor Matched",
        message: "Your blood request has been accepted by #{blood_donation_request.donor_profile.user.name}.",
        notifiable: blood_donation_request.blood_request
      )
    end
  end
end
