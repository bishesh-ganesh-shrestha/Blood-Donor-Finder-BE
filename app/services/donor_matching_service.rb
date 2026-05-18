class DonorMatchingService
  def initialize(blood_request)
    @blood_request = blood_request
  end

  def call
    compatible_groups =
      BloodCompatibilityService.compatible_donors(
        @blood_request.blood_group
      )

    donors = DonorProfile
               .includes(:user)
               .where(
                 blood_group: compatible_groups,
                 available: true
               )

    ranked_donors = donors.map do |donor|
      build_donor_data(donor)
    end

    ranked_donors.sort_by do |donor|
      -donor[:priority_score]
    end
  end

  private

  def build_donor_data(donor)
    distance = DistanceCalculationService.calculate(
      @blood_request.latitude,
      @blood_request.longitude,
      donor.latitude,
      donor.longitude
    )

    priority_score =
      DonorPriorityService.calculate(
        donor: donor,
        distance: distance
      )

    {
      donor_id: donor.id,
      donor_name: donor.user.name,
      blood_group: donor.blood_group,
      distance_km: distance.round(2),
      priority_score: priority_score,
      verified: donor.verified,
      available: donor.available
    }
  end
end
