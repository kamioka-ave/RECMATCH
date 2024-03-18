class ShareholderMeetingOnProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :shareholder_meeting_on, :date
    add_column :projects, :board_meeting_on, :date
    add_column :project_drafts, :shareholder_meeting_on, :date
    add_column :project_drafts, :board_meeting_on, :date
    add_column :project_histories, :shareholder_meeting_on, :date
    add_column :project_histories, :board_meeting_on, :date
  end
end
