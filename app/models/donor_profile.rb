class DonorProfile < ApplicationRecord
  belongs_to :user

  has_many :blood_donation_requests, dependent: :destroy

  BLOOD_GROUPS = %w[A+ A- B+ B- AB+ AB- O+ O-].freeze
  DONATION_GAP = 120.days

  validates :blood_group, presence: true,
                           inclusion: { in: BLOOD_GROUPS }

  validates :latitude, :longitude, presence: true
  validates :user_id, uniqueness: true

  validate :eligible_for_donation

  def available?
    return true if last_donated_at.blank?

    last_donated_at <= DONATION_GAP.ago
  end

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
