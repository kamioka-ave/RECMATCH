class DropFinancialStatements < ActiveRecord::Migration[5.2]
  def change
    drop_table :financial_statements
  end
end
