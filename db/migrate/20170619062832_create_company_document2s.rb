class CreateCompanyDocument2s < ActiveRecord::Migration[5.0]
  def change
    create_table :company_documents do |t|
      t.integer :company_id
      t.integer :admin_id
      t.string :name
      t.string :file
      t.text :description

      t.timestamps
    end
  end
end
