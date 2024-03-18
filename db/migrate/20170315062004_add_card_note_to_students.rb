class AddCardNoteToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :card_note, :text
  end
end
