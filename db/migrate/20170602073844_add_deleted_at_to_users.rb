class AddDeletedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :deleted_at, :datetime, after: :updated_at
    add_index :users, :deleted_at
    add_column :profiles, :deleted_at, :datetime, after: :updated_at
    add_index :profiles, :deleted_at
    add_column :accounts, :deleted_at, :datetime, after: :updated_at
    add_index :accounts, :deleted_at
    add_column :student_agreements, :deleted_at, :datetime, after: :updated_at
    add_index :student_agreements, :deleted_at
    add_column :company_agreements, :deleted_at, :datetime, after: :updated_at
    add_index :company_agreements, :deleted_at
  end
end
