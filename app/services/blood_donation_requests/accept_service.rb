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

        accept_current_request!

        cancel_other_requests!(blood_request)

        update_blood_request!(blood_request)

        notify_blood_requester
      end

      blood_donation_request
    end

    private

    def validate_request_status!(blood_request)
      unless blood_request.status == "open"
        raise StandardError,
              "Blood request is no longer accepting donors"
      end
    end

    def accept_current_request!
      blood_donation_request.update!(
        status: "accepted"
      )
    end

    def cancel_other_requests!(blood_request)
      blood_request
        .blood_donation_requests
        .where.not(id: blood_donation_request.id)
        .where(status: "pending")
        .update_all(status: "cancelled")
    end

    def update_blood_request!(blood_request)
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
