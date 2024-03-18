class AddFileToStudentChangeNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :student_change_notifications, :file, :string, after: :bank_modified
  end
end
