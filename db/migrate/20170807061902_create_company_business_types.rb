class CreateCompanyBusinessTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :company_business_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
