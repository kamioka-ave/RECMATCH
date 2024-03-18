class AddStatusToCompanyDocuments < ActiveRecord::Migration[4.2]
  def up
    add_column :company_documents, :status, :integer, default: 0, null: false
  end

  def down
    remove_column :company_documents, :status
  end
end
