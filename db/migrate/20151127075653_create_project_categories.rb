class CreateProjectCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :project_categories do |t|
      t.integer :project_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
