class CreateCompanyGraphData < ActiveRecord::Migration[4.2]
  def change
    create_table :company_graph_data do |t|
      t.integer :company_graph_id
      t.string :label
      t.integer :data

      t.timestamps null: false
    end
  end
end
