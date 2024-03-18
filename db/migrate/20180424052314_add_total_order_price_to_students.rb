class AddTotalOrderPriceToStudents < ActiveRecord::Migration[5.1]
  def up
    add_column :students, :total_order_count, :integer, default: 0, null: false
    add_column :students, :total_order_price, :integer, default: 0, null: false
    add_column :students, :total_investment_price, :integer, default: 0, null: false
    Student.all.each(&:refresh_total_order!)
  end

  def down
    remove_column :students, :total_order_count
    remove_column :students, :total_order_price
    remove_column :students, :total_investment_price
  end
end
