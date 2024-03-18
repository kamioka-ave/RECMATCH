class AddIsMailTargetToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :is_mail_target, :boolean, null: false, default: true
  end
end
