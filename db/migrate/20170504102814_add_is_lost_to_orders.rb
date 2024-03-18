class AddIsLostToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :is_lost, :boolean, default: false, null: false, after: :status
  end
end
