class AddLockedAtToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :locked_at, :datetime
    add_column :students, :lock_reason, :text
  end
end
