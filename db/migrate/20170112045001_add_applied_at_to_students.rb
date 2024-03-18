class AddAppliedAtToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :applied_at, :datetime
    add_column :students, :approved_at, :datetime
  end
end
