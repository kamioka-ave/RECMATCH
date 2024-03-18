class CreateStudentHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :student_histories do |t|
      t.integer :student_id
      t.string :last_name
      t.string :first_name
      t.string :last_name_kana
      t.string :first_name_kana
      t.string :nickname
      t.integer :gender
      t.date :birth_on
      t.string :zip_code
      t.integer :prefecture_id
      t.string :city
      t.string :address1
      t.string :address2
      t.string :phone
      t.string :phone_mobile
      t.integer :university
      t.string :university_name
      t.boolean :bunri
      t.integer :depart
      t.integer :graduation_year
      t.integer :graduation_month
      t.integer :industry_1
      t.integer :occupation_1
      t.string :toeic_score
      t.integer :revision


      t.timestamps
    end
  end
end
