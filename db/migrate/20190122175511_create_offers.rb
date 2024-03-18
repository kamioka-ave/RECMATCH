class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.integer :company_id
      t.integer :student_id
      t.integer :project_id
      t.integer :event_id
      t.integer :offer_type
      t.integer :status, null: false, default: 0
      t.text :description
      t.date :closing_date

      t.timestamps
    end
  end
end
