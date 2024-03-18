class CreateQuestionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :question_categories do |t|
      t.string :type
      t.string :name
      t.integer :rank, default: 0, null: false

      t.timestamps
    end
  end
end
