class AddDelivAtToStudentTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :student_transactions, :deliv_at, :datetime
    add_column :company_transactions, :payment_at, :datetime
  end
end
