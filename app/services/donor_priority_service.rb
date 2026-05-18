class DonorPriorityService
  def self.calculate(donor:, distance:)
    score = 0

    score += verification_score(donor)
    score += distance_score(distance)
    score += activity_score(donor)

    score
  end

  def self.verification_score(donor)
    donor.verified ? 30 : 0
  end

  def self.distance_score(distance)
    case distance
    when 0..2
      50
    when 2..5
      40
    when 5..10
      25
    else
      10
    end
  end

  def self.activity_score(donor)
    return 0 unless donor.last_active_at

    if donor.last_active_at > 1.hour.ago
      20
    elsif donor.last_active_at > 1.day.ago
      10
    else
      0
    end
  end
end
