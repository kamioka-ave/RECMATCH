class RemoveOrderPriceFromTransactionRecords < ActiveRecord::Migration[5.0]
  def change
    rename_column :transaction_records, :execution_amount, :amount
    remove_column :transaction_records, :order_amount
    remove_column :transaction_records, :order_unit_price
    remove_column :transaction_records, :execution_unit_price
    remove_column :transaction_records, :order_price
    remove_column :transaction_records, :execution_price
    remove_column :transaction_records, :order_at
    remove_column :transaction_records, :succeeded_at
    remove_column :transaction_records, :execution_at
    remove_column :transaction_records, :payment_at
    remove_column :transaction_records, :payment_due_at
    remove_column :transaction_records, :deliv_at
    remove_column :transaction_records, :deliv_due_at
    remove_column :transaction_records, :canceled_at
    remove_column :transaction_records, :rebated_at
    remove_column :transaction_records, :commission_rate
    remove_column :transaction_records, :commission_due_at
    remove_column :transaction_records, :commission_at
  end
end
