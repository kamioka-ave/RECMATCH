class AddCanceledAtToStudentTtansactions < ActiveRecord::Migration[4.2]
  def change
    add_column :student_transactions, :payment_due_at, :datetime
    add_column :student_transactions, :deliv_due_at, :datetime
    add_column :student_transactions, :canceled_at, :datetime
    add_column :student_transactions, :rebated_at, :datetime
    add_column :company_transactions, :payment_due_at, :datetime
    add_column :company_transactions, :deliv_due_at, :datetime
    add_column :company_transactions, :canceled_at, :datetime
    add_column :company_transactions, :commission_due_at, :datetime
    add_column :company_transactions, :commission_at, :datetime
  end
end
