class CreateChatQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_questions do |t|
      t.integer :user_id
      t.text    :question
      t.text    :answer
      t.integer :question_id
      t.string  :facebook_id
      t.string  :line_id
      t.string  :conversation_id
      t.string  :dialog_node
      t.integer :dialog_turn_counter
      t.integer :dialog_request_counter
      t.timestamps
    end
  end
end
