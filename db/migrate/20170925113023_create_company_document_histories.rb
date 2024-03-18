class CreateCompanyDocumentHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :company_document_histories do |t|
      t.integer :company_id
      t.integer :admin_id
      t.string :name
      t.string :file
      t.text :description, limit: 65535
      t.string :change

      t.timestamps
    end
  end
end
