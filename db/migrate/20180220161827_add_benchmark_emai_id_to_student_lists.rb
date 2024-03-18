class AddBenchmarkEmaiIdToStudentLists < ActiveRecord::Migration[5.1]
  def change
    add_column :student_lists, :benchmark_email_list_id, :integer, after: :id
    add_column :student_lists, :students_count, :integer, default: 0, null: false, after: :benchmark_email_list_id
    add_index :student_lists, :name, unique: true
  end
end
