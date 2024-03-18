class CreatePageDrafts < ActiveRecord::Migration[4.2]
  def change
    create_table :page_drafts do |t|
      t.integer :admin_id
      t.string :path
      t.string :title
      t.text :body
      t.string :description
      t.string :keywords
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
  end
end
