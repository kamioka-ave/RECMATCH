class CreateStudentInterests < ActiveRecord::Migration[4.2]
  def change
    create_table :student_interests do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
