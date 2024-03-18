class AddLastReadToGroupChatMember < ActiveRecord::Migration[5.2]
  def change
    add_column :group_chat_members, :last_read_notification, :datetime
  end
end
