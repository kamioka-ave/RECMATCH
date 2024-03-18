class CreateStudentApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :student_applicants do |t|
      t.integer :student_id
      t.integer :status
      t.datetime :book_at
      t.datetime :book1_at
      t.datetime :book2_at
      t.datetime :book3_at

      t.timestamps
    end
  end
end