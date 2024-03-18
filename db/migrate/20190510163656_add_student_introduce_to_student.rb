class AddStudentIntroduceToStudent < ActiveRecord::Migration[5.2]
  def up
    add_column :students, :introduce, :text, after: :qualifications
  end

  def down
    remove_column :students, :introduce, :text
  end
end
