class DonorTrackingService
  def self.broadcast_location(donation_request, latitude, longitude)
    donation_request.update(
      donor_latitude: latitude,
      donor_longitude: longitude
    )

    Pusher.trigger(
      "donation-tracking-#{donation_request.id}",
      "location-updated",
      {
        latitude: latitude,
        longitude: longitude
      }
    )
  end
end
