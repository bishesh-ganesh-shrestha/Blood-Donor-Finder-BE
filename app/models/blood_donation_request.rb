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
  after_update :update_donor_last_donated_at, if: :saved_change_to_completed?

  private

  def set_default_status
    self.status ||= "pending"
  end

  def saved_change_to_completed?
    saved_change_to_status? && status == "completed"
  end

  def update_donor_last_donated_at
    donor_profile.update!(last_donated_at: Time.current)
  end
end
