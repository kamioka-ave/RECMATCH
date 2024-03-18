class RemovePdf5FromCompanyAgreements < ActiveRecord::Migration[5.0]
  def change
    remove_column :company_agreements, :pdf5
  end
end
