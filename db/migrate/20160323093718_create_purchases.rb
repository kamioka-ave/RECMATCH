class CreatePurchases < ActiveRecord::Migration[4.2]
  def change
    create_table :purchases do |t|
      t.integer :order_id
      t.string :shop_id
      t.string :access_id
      t.string :access_pass

      t.timestamps null: false
    end
  end
end
