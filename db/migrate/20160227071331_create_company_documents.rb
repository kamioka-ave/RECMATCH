class CreateCompanyDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :company_documents do |t|
      t.integer :company_id
      t.string :contract
      t.string :full_registry_records_certificate
      t.string :seal_registration_certificate
      t.string :address_certificate
      t.string :representative_identification
      t.string :representative_address_certificate
      t.string :substantially_ruler_notification_form
      t.string :shareholders_list
      t.string :business_plan
      t.string :application_form
      t.string :financial_statement
      t.string :tax_certificate

      t.timestamps null: false
    end
  end
end
