class CreateInflowParams < ActiveRecord::Migration[5.2]
  def change
    create_table :inflow_params do |t|
      t.integer :inflow_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
