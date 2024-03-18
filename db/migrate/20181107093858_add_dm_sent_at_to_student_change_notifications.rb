class AddDmSentAtToStudentChangeNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :student_change_notifications, :dm_sent_at, :datetime, after: :notified_at
    add_column :student_change_notifications, :locked_at, :datetime, after: :dm_sent_at
  end
end
