class AddRejectedAtToStaff < ActiveRecord::Migration[5.2]
  def change
    add_column :staffs, :rejected_at, :datetime
  end
end
