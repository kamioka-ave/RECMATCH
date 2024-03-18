class AddPriceInOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :price, :integer
    add_column :orders, :unit_price, :integer
    change_column :student_transactions, :order_price, :integer
    change_column :company_transactions, :order_price, :integer
  end
end
