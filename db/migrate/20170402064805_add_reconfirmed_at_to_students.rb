class AddReconfirmedAtToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :reconfirm_applied_at, :datetime
    add_column :students, :reconfirmed_at, :datetime
  end
end
