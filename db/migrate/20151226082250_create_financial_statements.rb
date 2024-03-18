class CreateFinancialStatements < ActiveRecord::Migration[4.2]
  def change
    create_table :financial_statements do |t|
      t.integer :project_id
      t.string :statement
      t.text :note

      t.timestamps null: false
    end
  end
end
