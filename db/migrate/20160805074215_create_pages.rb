class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :pages do |t|
      t.integer :page_draft_id
      t.string :path
      t.string :title
      t.text :body
      t.string :description
      t.string :keywords

      t.timestamps null: false
    end
  end
end
