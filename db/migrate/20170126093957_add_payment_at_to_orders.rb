class AddPaymentAtToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :payment_at, :datetime
  end
end
