class AddStatusToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :status, :integer, default: 0, null: false
  end
end
