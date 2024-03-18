class CreateGroupChats < ActiveRecord::Migration[5.1]
  def change
    create_table :group_chats do |t|
      t.references :group_chat_category
      t.integer :message_count, default: 0, null: false

      t.timestamps
    end
  end
end
