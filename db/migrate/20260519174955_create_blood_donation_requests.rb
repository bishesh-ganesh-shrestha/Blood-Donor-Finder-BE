class CreateBloodDonationRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :blood_donation_requests do |t|
      t.references :blood_request, null: false, foreign_key: true
      t.references :donor_profile, null: false, foreign_key: true
      t.string :status
      t.text :message
      t.datetime :responded_at

      t.timestamps
    end
  end
end
