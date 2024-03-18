class CreateQuestionQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :question_questions do |t|
      t.integer :parent_id
      t.integer :question_id

      t.timestamps
    end
  end
end
