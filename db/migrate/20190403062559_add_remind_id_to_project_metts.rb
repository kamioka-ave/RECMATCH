class AddRemindIdToProjectMetts < ActiveRecord::Migration[5.2]
  def up
    add_column :project_meets, :remind_company_job_id, :integer
    add_column :project_meets, :remind_student_job_id, :integer
  end

  def down
    remove_column :project_meets, :remind_company_job_id
    remove_column :project_meets, :remind_student_job_id
  end
end
