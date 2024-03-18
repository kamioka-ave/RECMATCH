class AddUserIdToSummernotes < ActiveRecord::Migration[4.2]
  def up
    add_column :summernotes, :user_id, :integer
  end

  def down
    remove_column :summernotes, :user_id
  end
end
