class CreateStudentListEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :student_list_emails do |t|
      t.integer :student_list_id
      t.integer :admin_id
      t.integer :job_id
      t.string :subject
      t.text :plain
      t.text :rich
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
