class AddStatusAndRankingToGroupChatCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :group_chat_categories, :status, :integer, default: 1
    add_column :group_chat_categories, :ranking, :integer
  end
end
