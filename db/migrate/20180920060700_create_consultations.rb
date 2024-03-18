class CreateConsultations < ActiveRecord::Migration[5.1]
  def change
    create_table :consultations do |t|
      t.references :supporter, foreign_key: true
      t.integer :company_id
      t.references :group_chat_category, foreign_key: true

      t.timestamps
    end
  end
end
