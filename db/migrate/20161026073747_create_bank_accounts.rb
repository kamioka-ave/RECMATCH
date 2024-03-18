class CreateBankAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :bank_accounts do |t|
      t.integer :project_id
      t.integer :branch_code
      t.integer :account_type
      t.integer :account_number

      t.timestamps null: false
    end
  end
end
