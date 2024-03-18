class CreateOrderInvoices < ActiveRecord::Migration[4.2]
  def up
    drop_table :project_invoices
    drop_table :bank_accounts

    create_table :order_invoices do |t|
      t.integer :order_id
      t.date :date
      t.string :name
      t.string :name_kana
      t.string :kana
      t.date :payment_due_at
      t.integer :total_due
      t.string :bank_name
      t.string :bank_branch_code
      t.string :bank_branch_name
      t.string :bank_account_type
      t.integer :bank_account_number
      t.string :bank_account_name
      t.string :bank_account_name_kana

      t.timestamps null: false
    end
  end

  def down
    drop_table :order_invoices
  end
end
