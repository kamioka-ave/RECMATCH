class AddRevisionToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :revision, :integer, default: 0, null: false
  end
end
