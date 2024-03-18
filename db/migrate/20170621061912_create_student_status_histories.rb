class CreateStudentStatusHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :student_status_histories do |t|
      t.integer :student_id
      t.integer :status
      t.boolean :is_identification_passed
      t.boolean :is_antisocial_check_passed
      t.string :mail_subject
      t.text :mail_body

      t.timestamps
    end
  end
end
