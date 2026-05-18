class AddLastActiveAtToDonorProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :donor_profiles, :last_active_at, :datetime
  end
end
