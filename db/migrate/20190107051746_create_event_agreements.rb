class CreateEventAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :event_agreements do |t|
      t.integer :company_id
      t.boolean :agree_with_clause, null: false, default: 0
      t.boolean :agree_with_pre_judge, null: false, default: 0

      t.timestamps
    end
  end
end
