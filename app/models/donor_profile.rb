class DonorProfile < ApplicationRecord
  belongs_to :user

  has_many :blood_donation_requests, dependent: :destroy

  BLOOD_GROUPS = %w[A+ A- B+ B- AB+ AB- O+ O-].freeze

  validates :blood_group, presence: true,
                           inclusion: { in: BLOOD_GROUPS }

  validates :latitude, :longitude, presence: true

  validate :eligible_for_donation

  private

  def eligible_for_donation
    return if last_donated_at.blank?

    if last_donated_at > 3.months.ago
      errors.add(
        :last_donated_at,
        "Donor is not yet eligible to donate again"
      )
    end
  end
end
