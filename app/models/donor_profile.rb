class DonorProfile < ApplicationRecord
  belongs_to :user

  has_many :blood_donation_requests, dependent: :destroy

  BLOOD_GROUPS = %w[A+ A- B+ B- AB+ AB- O+ O-].freeze
  DONATION_GAP = 120.days

  validates :blood_group, presence: true,
                           inclusion: { in: BLOOD_GROUPS }

  validates :latitude, :longitude, presence: true
  validates :user_id, uniqueness: true

  scope :available, -> {
    where(
      "last_donated_at IS NULL OR last_donated_at <= ?",
      DONATION_GAP.ago
    )
  }

  scope :unavailable, -> {
    where(
      "last_donated_at > ?",
      DONATION_GAP.ago
    )
  }

  def available?
    return true if last_donated_at.blank?

    last_donated_at <= DONATION_GAP.ago
  end

  def available
    available?
  end
end
