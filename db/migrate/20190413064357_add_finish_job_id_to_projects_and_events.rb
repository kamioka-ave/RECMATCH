class AddFinishJobIdToProjectsAndEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :finish_job_id, :integer
    add_column :events, :finish_job_id, :integer
  end

  def down
    remove_column :projects, :finish_job_id
    remove_column :events, :finish_job_id
  end
end
