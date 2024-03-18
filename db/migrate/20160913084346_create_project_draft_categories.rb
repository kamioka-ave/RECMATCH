class CreateProjectDraftCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :project_draft_categories do |t|
      t.integer :project_draft_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
