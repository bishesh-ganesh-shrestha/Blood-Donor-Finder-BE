class DistanceCalculationService
  EARTH_RADIUS_KM = 6371

  def self.calculate(lat1, lon1, lat2, lon2)
    dlat = to_radians(lat2 - lat1)
    dlon = to_radians(lon2 - lon1)

    a =
      Math.sin(dlat / 2)**2 +
      Math.cos(to_radians(lat1)) *
      Math.cos(to_radians(lat2)) *
      Math.sin(dlon / 2)**2

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    EARTH_RADIUS_KM * c
  end

  def self.to_radians(degree)
    degree * Math::PI / 180
  end
end
