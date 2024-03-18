class AddCommissionToTransactionRecords < ActiveRecord::Migration[4.2]
  def change
    add_column :transaction_records, :commission_rate, :integer, after: :rebated_at
  end
end
