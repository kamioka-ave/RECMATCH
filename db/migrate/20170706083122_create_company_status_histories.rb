class CreateCompanyStatusHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :company_status_histories do |t|
      t.integer :company_id
      t.integer :updater_id
      t.integer :status
      t.boolean :is_identification_passed
      t.boolean :is_antisocial_check_passed

      t.timestamps
    end
  end
end
