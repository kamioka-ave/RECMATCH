class CreateSites < ActiveRecord::Migration[4.2]
  def change
    create_table :sites do |t|
      t.integer :solicit_max, limit: 8

      t.timestamps null: false
    end
  end
end
