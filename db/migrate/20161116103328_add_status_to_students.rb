class AddStatusToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :status, :integer, default: 0, null: false
    add_column :students, :activation_code, :string
    add_column :students, :activated_at, :datetime
  end
end
