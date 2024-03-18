class CreateGroupChatCategorySupporters < ActiveRecord::Migration[5.1]
  def change
    create_table :group_chat_category_supporters do |t|
      t.references :group_chat_category, foreign_key: true
      t.references :supporter, foreign_key: true

      t.timestamps
    end
  end
end
