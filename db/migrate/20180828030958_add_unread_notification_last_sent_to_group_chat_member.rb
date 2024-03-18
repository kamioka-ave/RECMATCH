class AddUnreadNotificationLastSentToGroupChatMember < ActiveRecord::Migration[5.1]
  def change
    add_column :group_chat_members, :unread_notification_last_sent, :datetime
  end
end
