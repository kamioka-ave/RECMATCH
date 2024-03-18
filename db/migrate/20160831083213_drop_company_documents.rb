class DropCompanyDocuments < ActiveRecord::Migration[4.2]
  def change
    drop_table :company_documents
  end
end
