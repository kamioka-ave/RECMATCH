class CreateCompanyAgreements < ActiveRecord::Migration[5.0]
  def change
    create_table :company_agreements do |t|
      t.integer :user_id
      t.integer :company_id
      t.boolean :pdf1, default: true, null: false
      t.boolean :pdf2, default: false, null: false
      t.boolean :pdf3, default: false, null: false
      t.boolean :pdf4, default: false, null: false
      t.boolean :pdf5, default: false, null: false
      t.boolean :agreement, default: false, null: false

      t.timestamps
    end
  end
end
