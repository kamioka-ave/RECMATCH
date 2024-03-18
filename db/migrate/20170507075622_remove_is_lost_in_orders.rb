class RemoveIsLostInOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :is_lost
  end
end
