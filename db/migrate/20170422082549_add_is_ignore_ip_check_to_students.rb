class AddIsIgnoreIpCheckToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :is_ignore_ip_check, :boolean, default: false, null: false
    add_column :students, :is_ignore_phone_check, :boolean, default: false, null: false
  end
end
