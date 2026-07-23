class RemoveAvailableFromDonorProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :donor_profiles, :available, :boolean
  end
end
