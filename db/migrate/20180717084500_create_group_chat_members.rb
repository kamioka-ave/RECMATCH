class CreateGroupChatMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_chat_members do |t|
      t.references :member, polymorphic: true
      t.references :group_chat, foreign_key: true
      t.timestamp :last_read

      t.timestamps
    end
  end
end
