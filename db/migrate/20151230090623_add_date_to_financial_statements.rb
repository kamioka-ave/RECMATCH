class AddDateToFinancialStatements < ActiveRecord::Migration[4.2]
  def up
    add_column :financial_statements, :date, :date
  end

  def down
    remove_column :financial_statements, :date
  end
end
