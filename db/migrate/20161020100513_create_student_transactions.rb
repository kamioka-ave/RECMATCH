class CreateStudentTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :student_transactions do |t|
      t.integer :student_id
      t.integer :product_id
      t.integer :order_id
      t.datetime :order_at
      t.datetime :execution_at
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

      t.timestamps null: false
    end
  end
end
