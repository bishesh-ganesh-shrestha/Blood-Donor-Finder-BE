class CreateDonorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :donor_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :blood_group
      t.string :location
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :last_donated_at
      t.boolean :available
      t.boolean :verified

      t.timestamps
    end
  end
end
