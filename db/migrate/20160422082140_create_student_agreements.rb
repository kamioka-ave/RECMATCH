class CreateStudentAgreements < ActiveRecord::Migration[4.2]
  def change
    create_table :student_agreements do |t|
      t.integer :user_id
      t.integer :student_id
      t.boolean :pdf1, default: true, null: false
      t.boolean :pdf2, default: false, null: false
      t.boolean :pdf3, default: false, null: false
      t.boolean :pdf4, default: false, null: false
      t.boolean :pdf5, default: false, null: false
      t.boolean :pdf6, default: false, null: false
      t.boolean :agreement, default: false, null: false

      t.timestamps null: false
    end
  end
end
