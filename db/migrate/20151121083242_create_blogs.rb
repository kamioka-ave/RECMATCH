class CreateBlogs < ActiveRecord::Migration[4.2]
  def change
    create_table :blogs do |t|
      t.integer :admin_id
      t.string :title
      t.text :body
      t.string :image

      t.timestamps null: false
    end
  end
end
