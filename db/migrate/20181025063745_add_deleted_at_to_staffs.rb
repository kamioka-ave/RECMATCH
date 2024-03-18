class AddDeletedAtToStaffs < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :deleted_at, :datetime
    add_index :staffs, :deleted_at
  end
end
