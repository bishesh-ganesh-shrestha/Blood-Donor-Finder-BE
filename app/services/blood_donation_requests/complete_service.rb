# frozen_string_literal: true

module BloodDonationRequests
  class CompleteService
    attr_reader :blood_donation_request

    def initialize(blood_donation_request)
      @blood_donation_request = blood_donation_request
    end

    def call
      blood_request = blood_donation_request.blood_request

      blood_request.with_lock do
        validate!

        complete_donation!

        increment_units!(blood_request)

        fulfill_request_if_completed!(blood_request)
      end

      blood_donation_request
    end

    private

    def validate!
      unless blood_donation_request.status == "accepted"
        raise StandardError,
              "Only accepted donation requests can be completed."
      end
    end

    def complete_donation!
      blood_donation_request.update!(
        status: "completed"
      )
    end

    def increment_units!(blood_request)
      blood_request.increment!(:units_collected)
    end

    def fulfill_request_if_completed!(blood_request)
      return unless blood_request.units_collected >= blood_request.units_required

      blood_request.update!(
        status: "fulfilled"
      )

      blood_request
        .blood_donation_requests
        .where(status: "pending")
        .update_all(status: "cancelled")
    end
  end
end
