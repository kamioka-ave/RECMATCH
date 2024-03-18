class AddTypeToCompanyDocuments < ActiveRecord::Migration[5.1]
  def up
    add_column :company_documents, :type, :string, default: 'Company::OtherDocument', after: :id
    add_column :company_documents, :document_type, :integer, after: :type
    add_column :company_documents, :comment, :text, after: :description
    add_column :company_documents, :authorizer_id, :integer, after: :comment
    add_column :company_documents, :status, :integer, default: 0, null: false, after: :authorizer_id

    add_column :company_document_histories, :type, :string, after: :id
    add_column :company_document_histories, :document_type, :integer, after: :type
    add_column :company_document_histories, :comment, :text, after: :description
    add_column :company_document_histories, :authorizer_id, :integer, after: :comment
    add_column :company_document_histories, :status, :integer, default: 0, null: false, after: :authorizer_id

    # CompanyDocumentHistory.all.each do |history|
    #   history.update_column(:type, 'Company::OtherDocumentHistory')
    # end
    #
    # CompanyReview.all.each do |review|
    #   if review.review_type < 100
    #     document = Company::ReviewDocument.new(
    #       document_type: review.review_type,
    #       company_id: review.company_id,
    #       admin_id: review.admin_id,
    #       name: CompanyReview.names_with_review_type.key(review.review_type),
    #       file: review.file.file,
    #       comment: review.comment,
    #       authorizer_id: review.authorizer_id,
    #       status: review.status,
    #       created_at: review.created_at,
    #       updated_at: review.updated_at
    #     )
    #   else
    #     document = Company::JccDocument.new(
    #       document_type: review.review_type,
    #       company_id: review.company_id,
    #       admin_id: review.admin_id,
    #       name: CompanyReview.names_with_admin_review_type.key(review.review_type),
    #       file: review.file.file,
    #       comment: review.comment,
    #       authorizer_id: review.authorizer_id,
    #       status: review.status,
    #       created_at: review.created_at,
    #       updated_at: review.updated_at
    #     )
    #   end
    #
    #   document.will_save_history = false
    #   document.save!
    # end
    #
    # Company.all.each do |company|
    #   if company.financial_statement.present?
    #     document = Company::PreviewDocument.new(
    #       document_type: Company::PreviewDocument::FINANCIAL_STATEMENT,
    #       company_id: company.id,
    #       name: '税務申告書一式（1期分）',
    #       file: company.financial_statement.file
    #     )
    #     document.will_save_history = false
    #     document.save!
    #   end
    #
    #   if company.share_holders.present?
    #     document = Company::PreviewDocument.new(
    #       document_type: Company::PreviewDocument::SHARE_HOLDERS,
    #       company_id: company.id,
    #       name: '株主名簿',
    #       file: company.share_holders.file
    #     )
    #     document.will_save_history = false
    #     document.save!
    #   end
    #
    #   if company.full_registry_records_certificate.present?
    #     document = Company::PreviewDocument.new(
    #       document_type: Company::PreviewDocument::FULL_REGISTRY_RECORDS_CERTIFICATE,
    #       company_id: company.id,
    #       name: '履歴事項全部証明書',
    #       file: company.full_registry_records_certificate.file
    #     )
    #     document.will_save_history = false
    #     document.save!
    #   end
    #
    #   if company.business_plan.present?
    #     document = Company::PreviewDocument.new(
    #       document_type: Company::PreviewDocument::BUSINESS_PLAN,
    #       company_id: company.id,
    #       name: '事業計画書',
    #       file: company.business_plan.file
    #     )
    #     document.will_save_history = false
    #     document.save!
    #   end
    # end
  end

  def down
    remove_column :company_documents, :type
    remove_column :company_documents, :document_type
    remove_column :company_documents, :comment
    remove_column :company_documents, :authorizer_id
    remove_column :company_documents, :status

    remove_column :company_document_histories, :type
    remove_column :company_document_histories, :document_type
    remove_column :company_document_histories, :comment
    remove_column :company_document_histories, :authorizer_id
    remove_column :company_document_histories, :status
  end
end
