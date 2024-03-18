class AddIdentifiedAtToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :is_identification_passed, :boolean
    add_column :students, :identified_at, :datetime
    add_column :students, :identifier_id, :integer
    add_column :students, :is_antisocial_check_passed, :boolean
    add_column :students, :antisocial_checked_at, :datetime
    add_column :students, :antisocial_checker_id, :integer
    add_column :students, :approver_id, :integer
  end
end
