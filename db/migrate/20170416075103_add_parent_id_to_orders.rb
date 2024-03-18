class AddParentIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :parent_id, :integer, after: :id
  end
end
