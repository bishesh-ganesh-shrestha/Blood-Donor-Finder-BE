class BloodDonationRequest < ApplicationRecord
  belongs_to :blood_request
  belongs_to :donor_profile
  has_many :notifications, as: :notifiable, dependent: :destroy

  STATUSES = %w[
    pending
    accepted
    completed
    declined
    cancelled
  ].freeze

  validates :status,
            inclusion: { in: STATUSES }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end
