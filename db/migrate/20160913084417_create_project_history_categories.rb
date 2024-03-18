class CreateProjectHistoryCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :project_history_categories do |t|
      t.integer :project_history_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
