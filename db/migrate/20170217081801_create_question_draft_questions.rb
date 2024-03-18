class CreateQuestionDraftQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :question_draft_questions do |t|
      t.integer :question_draft_id
      t.integer :question_id

      t.timestamps
    end
  end
end
