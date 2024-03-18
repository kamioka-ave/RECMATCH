class CreateAffiliates < ActiveRecord::Migration[4.2]
  def change
    create_table :affiliates do |t|
      t.string :name
      t.text :description
      t.integer :reward
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :affiliates, :deleted_at
  end
end
