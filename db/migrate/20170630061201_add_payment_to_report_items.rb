class AddPaymentToReportItems < ActiveRecord::Migration[5.0]
  def change
    add_column :report_items, :payment, :integer, after: :deliv_at
    add_column :report_items, :payment_at, :datetime, after: :deliv_at
  end
end
