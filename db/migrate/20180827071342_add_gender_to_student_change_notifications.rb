class AddGenderToStudentChangeNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :student_change_notifications, :gender, :integer, after: :bank_modified
    add_column :student_change_notifications, :birth_on, :date, after: :gender
    add_column :student_change_notifications, :phone, :string, after: :birth_on
    add_column :student_change_notifications, :phone_mobile, :string, after: :phone
    add_column :student_change_notifications, :job, :integer, after: :phone_mobile
    add_column :student_change_notifications, :job_details, :string, after: :job
    add_column :student_change_notifications, :company, :string, after: :job_details
    add_column :student_change_notifications, :phone_company, :string, after: :company
    add_column :student_change_notifications, :email_company, :string, after: :phone_company
  end
end
