class CreateStudentListStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :student_list_students do |t|
      t.integer :student_list_id
      t.integer :student_id

      t.timestamps
    end
  end
end
