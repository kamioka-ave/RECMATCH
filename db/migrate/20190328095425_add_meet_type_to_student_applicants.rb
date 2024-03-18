class AddMeetTypeToStudentApplicants < ActiveRecord::Migration[5.2]
  def up
    add_column :student_applicants, :meet_type, :integer
  end

  def down
    remove_column :student_applicants, :meet_type
  end
end
