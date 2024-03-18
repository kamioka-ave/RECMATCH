class CreateRefferrals < ActiveRecord::Migration[4.2]
  def change
    create_table :refferrals do |t|
      t.integer :user_id
      t.integer :affiliate_id
      t.string :name

      t.timestamps null: false
    end
  end
end
