class AddRemindActivationJobIdToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :remind_activation_job_id, :integer, after: :waiting_activation_at
  end
end
