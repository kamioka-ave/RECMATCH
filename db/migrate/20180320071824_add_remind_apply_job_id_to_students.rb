class AddRemindApplyJobIdToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :remind_apply_job_id, :integer, after: :applied_at
    add_column :users, :remind_apply_job_id, :integer, after: :locked_at
  end
end
