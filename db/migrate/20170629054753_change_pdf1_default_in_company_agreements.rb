class ChangePdf1DefaultInCompanyAgreements < ActiveRecord::Migration[5.0]
  def change
    change_column_default :company_agreements, :pdf1, false
  end
end
