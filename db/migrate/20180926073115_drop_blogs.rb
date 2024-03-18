class DropBlogs < ActiveRecord::Migration[5.2]
  def change
    drop_table :blogs
  end
end
