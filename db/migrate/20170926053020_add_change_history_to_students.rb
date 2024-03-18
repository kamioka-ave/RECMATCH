class AddChangeHistoryToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :change_history, :text, after: :qualifications
  end
end
