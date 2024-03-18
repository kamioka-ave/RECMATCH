class AddStudentTransactionIdToReportItems < ActiveRecord::Migration[5.0]
  def change
    add_column :report_items, :student_transaction_record_id, :integer, after: :report_id
  end
end
