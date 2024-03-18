class AddTransactionAtToTransactionRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :transaction_records, :transaction_at, :datetime, after: :transaction_type
  end
end
