class CreateStaffGroupChatCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :staff_group_chat_categories do |t|
      t.references :staff, foreign_key: true
      t.references :group_chat_category, foreign_key: true
      t.references :group_chat, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
