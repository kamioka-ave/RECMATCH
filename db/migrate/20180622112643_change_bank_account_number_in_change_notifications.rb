class ChangeBankAccountNumberInChangeNotifications < ActiveRecord::Migration[5.1]
  def up
    change_column :student_change_notifications, :bank_account_number, :string
    change_column :student_change_notifications, :bank_account_number_prev, :string
  end

  def down
    change_column :student_change_notifications, :bank_account_number, :integer
    change_column :student_change_notifications, :bank_account_number_prev, :integer
  end
end
