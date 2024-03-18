class AddContractConfirmedToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :contract_confirmed, :boolean, default: false, null: false
  end
end
