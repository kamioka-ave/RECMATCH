class AddUniqueIndexToCompanySupporters < ActiveRecord::Migration[5.1]
  def change
    add_index :company_supporters, [:company_id, :supporter_id], unique: true
  end
end
