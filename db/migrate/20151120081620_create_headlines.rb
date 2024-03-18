class CreateHeadlines < ActiveRecord::Migration[4.2]
  def change
    create_table :headlines do |t|
      t.integer :admin
      t.string :title
      t.text :body
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
