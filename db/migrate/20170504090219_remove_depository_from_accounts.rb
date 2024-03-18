class RemoveDepositoryFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :depository
    remove_column :accounts, :credit
    change_column :transaction_records, :depository, :integer, default: 0, null: false
    change_column :transaction_records, :credit, :integer, default: 0, null: false
    change_column :transaction_records, :balance, :integer, default: 0, null: false
  end
end
