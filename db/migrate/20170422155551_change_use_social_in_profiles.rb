class ChangeUseSocialInProfiles < ActiveRecord::Migration[5.0]
  def change
    change_column :profiles, :use_social, :boolean, default: false
  end
end
