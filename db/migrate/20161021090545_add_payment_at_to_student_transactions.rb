class AddPaymentAtToStudentTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :student_transactions, :payment_at, :datetime
    add_column :student_transactions, :user_id, :integer
    add_column :student_transactions, :project_id, :integer
    add_column :student_transactions, :company_id, :integer
  end
end
