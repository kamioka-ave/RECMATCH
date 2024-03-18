class AddSucceededAtInStudentTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :student_transactions, :succeeded_at, :datetime
    add_column :company_transactions, :succeeded_at, :datetime
  end
end
