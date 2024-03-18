class AddTotalOrderPriceToAdminStudentsDisplays < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_students_displays, :total_order_price, :boolean, default: false, null: false, after: :lock_reason
    add_column :admin_students_displays, :total_investment_price, :boolean, default: false, null: false, after: :total_order_price
    add_column :admin_students_displays, :investment_history, :boolean, default: false, null: false, after: :total_investment_price
    add_column :admin_students_displays, :current_sign_in_at, :boolean, default: false, null: false, after: :investment_history
  end
end
