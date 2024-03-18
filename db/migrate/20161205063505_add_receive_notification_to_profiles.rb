class AddReceiveNotificationToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :receive_notification, :boolean, default: true, null: false
  end
end
