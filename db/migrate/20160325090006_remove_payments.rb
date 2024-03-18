class RemovePayments < ActiveRecord::Migration[4.2]
  def up
    drop_table :payments
    rename_column :orders, :payment_id, :payment_method
  end

  def down
    create_table :payments do |t|
      t.string :name
      t.integer :charge

      t.timestamps null: false
    end
    rename_column :orders, :payment_method, :payment_id
  end
end
