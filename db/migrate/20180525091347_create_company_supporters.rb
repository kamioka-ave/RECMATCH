class CreateCompanySupporters < ActiveRecord::Migration[5.1]
  def change
    create_table :company_supporters do |t|
      t.integer :company_id
      t.integer :supporter_id
      t.integer :company_supporter_messages_count, default: 0, null: false

      t.timestamps
    end
  end
end
