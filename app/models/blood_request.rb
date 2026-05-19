class BloodRequest < ApplicationRecord
  belongs_to :user

  has_many :blood_donation_requests, dependent: :destroy

  BLOOD_GROUPS = %w[A+ A- B+ B- AB+ AB- O+ O-].freeze

  URGENCY_LEVELS = %w[normal urgent critical].freeze

  STATUSES = %w[open fulfilled cancelled].freeze

  validates :blood_group,
            presence: true,
            inclusion: { in: BLOOD_GROUPS }

  validates :urgency,
            presence: true,
            inclusion: { in: URGENCY_LEVELS }

  validates :status,
            inclusion: { in: STATUSES }

  validates :latitude, presence: true
  validates :longitude, presence: true

  validates :hospital_name, presence: true
  validates :patient_name, presence: true
  validates :contact_number, presence: true

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "open"
  end
end
