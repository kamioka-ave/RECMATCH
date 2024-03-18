class CreateCompanyGraphs < ActiveRecord::Migration[4.2]
  def change
    create_table :company_graphs do |t|
      t.integer :company_id
      t.string :name
      t.integer :rank

      t.timestamps null: false
    end
  end
end
