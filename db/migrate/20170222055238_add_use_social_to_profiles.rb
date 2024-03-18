class AddUseSocialToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :use_social, :boolean, default: true, null: false
  end
end
