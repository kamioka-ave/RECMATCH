class AddDeletedAtToGroupChatCategorySupporter < ActiveRecord::Migration[5.1]
  def change
    add_column :group_chat_category_supporters, :deleted_at, :datetime
    add_index :group_chat_category_supporters, :deleted_at
  end
end
