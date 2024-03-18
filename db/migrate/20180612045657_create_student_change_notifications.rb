class CreateStudentChangeNotifications < ActiveRecord::Migration[5.1]
  def up
    create_table :student_change_notifications do |t|
      t.integer :student_id
      t.string :first_name
      t.string :first_name_prev
      t.string :last_name
      t.string :last_name_prev
      t.string :first_name_kana
      t.string :first_name_kana_prev
      t.string :last_name_kana
      t.string :last_name_kana_prev
      t.string :zip_code
      t.string :zip_code_prev
      t.string :prefecture_id
      t.string :prefecture_id_prev
      t.string :city
      t.string :city_prev
      t.string :address1
      t.string :address1_prev
      t.string :address2
      t.string :address2_prev
      t.integer :bank_id
      t.integer :bank_id_prev
      t.integer :bank_branch_id
      t.integer :bank_branch_id_prev
      t.integer :bank_account_type
      t.integer :bank_account_type_prev
      t.integer :bank_account_number
      t.integer :bank_account_number_prev
      t.string :bank_account_name
      t.string :bank_account_name_prev
      t.boolean :name_modified, default: false, null: false
      t.boolean :address_modified, default: false, null: false
      t.boolean :bank_modified, default: false, null: false
      t.datetime :identification_updated_at
      t.datetime :notified_at
      t.string :confirmation_code
      t.datetime :confirmed_at
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end

  def down
    drop_table :student_change_notifications
  end
end
