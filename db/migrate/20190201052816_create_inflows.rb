class CreateInflows < ActiveRecord::Migration[5.2]
  def change
    create_table :inflows do |t|
      t.integer :user_id
      t.string :ab
      t.text :referer
      t.integer :segment

      t.timestamps
    end
  end
end
