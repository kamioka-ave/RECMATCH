class CreateAdminCompanies < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_companies do |t|
      t.integer :admin_id
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
