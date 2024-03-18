class AddConfirmationCodeSentAtToStudentChangeNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :student_change_notifications, :confirmation_code_sent_at, :datetime, after: :confirmation_code
  end
end
