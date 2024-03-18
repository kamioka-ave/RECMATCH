class AddTerms10AgreedToCompanyAgreements < ActiveRecord::Migration[5.0]
  def change
    add_column :company_agreements, :terms10_agreed, :boolean, after: :agreement
  end
end
