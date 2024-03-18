class AddExcludeNotificationToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :exclude_notification, :boolean, default: false, null: false, after: :receive_notification
  end
end
