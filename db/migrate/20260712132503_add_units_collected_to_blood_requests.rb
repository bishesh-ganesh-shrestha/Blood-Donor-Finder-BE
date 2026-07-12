class AddUnitsCollectedToBloodRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :blood_requests, :units_collected, :integer, null: false, default: 0
  end
end
