class CreateQuestionDrafts < ActiveRecord::Migration[5.0]
  def change
    create_table :question_drafts do |t|
      t.integer :question_category_id
      t.string :name
      t.text :asking
      t.text :answer
      t.integer :rank, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
