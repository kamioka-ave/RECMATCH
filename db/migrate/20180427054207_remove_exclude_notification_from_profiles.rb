class RemoveExcludeNotificationFromProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :profiles, :exclude_notification
  end
end
