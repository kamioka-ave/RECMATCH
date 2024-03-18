class CreateCompanyFares < ActiveRecord::Migration[5.2]
  def change
    create_table :company_fares do |t|
      t.integer :company_id
      t.integer :admin_id
      t.integer :priority_no
      t.integer :subject
      t.string :subject_note
      t.date :start_at
      t.date :end_at
      t.integer :price

      t.timestamps
    end
  end
end