class AddTrackingFieldsToBloodDonationRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :blood_donation_requests, :tracking_enabled, :boolean
    add_column :blood_donation_requests, :donor_latitude, :decimal
    add_column :blood_donation_requests, :donor_longitude, :decimal
  end
end
