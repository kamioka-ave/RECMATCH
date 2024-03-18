class AddUseOfFundsToCompanyDocuments < ActiveRecord::Migration[4.2]
  def up
    add_column :company_documents, :use_of_funds, :string
    add_column :company_documents, :expected_bs, :string
    add_column :company_documents, :expected_pl, :string
    add_column :company_documents, :expected_cash_flow, :string
    add_column :company_documents, :summary, :string
    add_column :company_documents, :profit_plan, :string
    add_column :company_documents, :accountant, :string
    add_column :company_documents, :financial_status, :string
  end

  def down
    remove_column :company_documents, :use_of_funds
    remove_column :company_documents, :expected_bs
    remove_column :company_documents, :expected_pl
    remove_column :company_documents, :expected_cash_flow
    remove_column :company_documents, :summary
    remove_column :company_documents, :profit_plan
    remove_column :company_documents, :accountant
    remove_column :company_documents, :financial_status
  end
end
