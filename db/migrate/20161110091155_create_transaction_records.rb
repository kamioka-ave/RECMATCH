class CreateTransactionRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :transaction_records do |t|
      t.string :type
      t.integer :user_id
      t.integer :company_id
      t.integer :student_id
      t.integer :project_id
      t.integer :product_id
      t.integer :order_id
      t.integer :order_amount
      t.integer :execution_amount
      t.integer :order_unit_price
      t.integer :execution_unit_price
      t.string :order_price
      t.integer :execution_price
      t.integer :transaction_type
      t.integer :depository
      t.integer :credit
      t.integer :balance
      t.datetime :order_at
      t.datetime :succeeded_at
      t.datetime :execution_at
      t.datetime :payment_at
      t.datetime :payment_due_at
      t.datetime :deliv_at
      t.datetime :deliv_due_at
      t.datetime :canceled_at
      t.datetime :rebated_at
      t.datetime :commission_due_at
      t.datetime :commission_at

      t.timestamps null: false
    end

    drop_table :student_transactions
    drop_table :company_transactions
  end
end
