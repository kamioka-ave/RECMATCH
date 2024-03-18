class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :first_name
      t.string :first_name_kana
      t.string :last_name
      t.string :last_name_kana

      t.timestamps
    end
  end
end
