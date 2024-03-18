class ChangeCapitalToCompanies < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :capital, :bigint
    change_column :companies, :sales_profit, :bigint
  end
end
