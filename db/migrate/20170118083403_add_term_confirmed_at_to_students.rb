class AddTermConfirmedAtToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :term_confirmed_at, :datetime
  end
end
