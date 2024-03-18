class ChangeFileInCompanyDocumentHistories < ActiveRecord::Migration[5.0]
  def up
    change_column :company_document_histories, :file, :text
  end

  def down
    change_column :company_document_histories, :file, :string
  end
end
