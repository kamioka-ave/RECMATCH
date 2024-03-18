class CreateGroupChatCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :group_chat_categories do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
