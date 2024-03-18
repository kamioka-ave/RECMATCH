class CreateProjectInvoices < ActiveRecord::Migration[4.2]
  def change
    create_table :project_invoices do |t|
      t.integer :project_id
      t.integer :user_id
      t.date :date
      t.string :name
      t.string :name_kana
      t.string :kana
      t.integer :total_due

      t.timestamps null: false
    end
  end
end
