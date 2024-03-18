class CreateStudents < ActiveRecord::Migration[4.2]
  def change
    create_table :students do |t|
      t.integer :user_id

      t.string :first_name
      t.string :first_name_kana
      t.string :last_name
      t.string :last_name_kana
      t.string :nickname
      t.string :gender
      t.date :birth_on
      t.string :zip_code
      t.integer :prefecture_id
      t.string :city
      t.string :address1
      t.string :address2
      t.string :phone
      t.string :phone_mobile

      t.boolean :bunri
      t.integer :university
      t.string :university_name
      t.string :depart
      t.string :depart_detail
      t.string :labo

      t.integer :industry_1
      t.integer :occupation_1
      t.integer :industry_2
      t.integer :occupation_2
      t.integer :industry_3
      t.integer :occupation_3
      t.boolean :intern_is
      t.string :intern_company
      t.string :intern_detail
      t.string :intern_company_2
      t.string :intern_detail_2
      t.string :intern_company_3
      t.string :intern_detail_3
      t.integer :graduation_year
      t.integer :graduation_month

      t.integer :toeic_score
      t.string :qualifications

      t.integer :p_communication
      t.integer :p_logical
      t.integer :p_challenge
      t.integer :p_lesdership
      t.integer :p_teamwork
      t.integer :p_global

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
