class CreateAggregations < ActiveRecord::Migration[5.1]
  def change
    create_table :aggregations do |t|
      t.string :type
      t.date :date
      t.integer :result

      t.timestamps
    end

    add_index :aggregations, [:type, :date], unique: true
  end
end
