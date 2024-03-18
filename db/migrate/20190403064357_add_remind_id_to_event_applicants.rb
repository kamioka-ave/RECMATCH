class AddRemindIdToEventApplicants < ActiveRecord::Migration[5.2]
  def up
    add_column :event_applicants, :remind_event_student_job_id, :integer
  end

  def down
    remove_column :event_applicants, :remind_event_student_job_id
  end
end
