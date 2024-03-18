class ChangeGenderInStudents < ActiveRecord::Migration[4.2]
  def change
    change_column :students, :gender, :integer
  end
end
