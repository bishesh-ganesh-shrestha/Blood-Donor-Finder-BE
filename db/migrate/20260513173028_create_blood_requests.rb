class CreateBloodRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :blood_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :blood_group
      t.decimal :latitude
      t.decimal :longitude
      t.string :urgency
      t.integer :units_required
      t.string :hospital_name
      t.string :patient_name
      t.string :contact_number
      t.string :status

      t.timestamps
    end
  end
end
