class AddDeletedAtToSupporters < ActiveRecord::Migration[5.2]
  def change
    add_column :supporters, :deleted_at, :datetime
    add_index :supporters, :deleted_at
  end
end
