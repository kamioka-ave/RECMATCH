class CreateChatMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_messages do |t|
      t.integer :company_id
      t.integer :student_id
      t.boolean :direct
      t.boolean :kidoku, null: false, default: 0
      t.text :description
      t.string :files

      t.timestamps
    end
  end
end
