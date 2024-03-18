class CreateReportItems < ActiveRecord::Migration[5.0]
  def change
    create_table :report_items do |t|
      t.integer :report_id
      t.integer :order_id
      t.datetime :deliv_at
      t.text :company_address

      t.timestamps
    end
  end
end
