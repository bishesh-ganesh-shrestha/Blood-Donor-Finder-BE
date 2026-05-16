class BloodCompatibilityService
  COMPATIBILITY_MAP = {
    "A+"  => [ "A+", "A-", "O+", "O-" ],
    "A-"  => [ "A-", "O-" ],
    "B+"  => [ "B+", "B-", "O+", "O-" ],
    "B-"  => [ "B-", "O-" ],
    "AB+" => [ "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" ],
    "AB-" => [ "AB-", "A-", "B-", "O-" ],
    "O+"  => [ "O+", "O-" ],
    "O-"  => [ "O-" ]
  }.freeze

  def self.compatible_donors(recipient_blood_group)
    COMPATIBILITY_MAP[recipient_blood_group] || []
  end
end
