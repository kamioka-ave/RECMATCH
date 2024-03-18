class ChangeEmployeesToStaffs < ActiveRecord::Migration[5.2]
  def change
    rename_table :employees, :staffs
  end
end
