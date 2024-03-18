class CreateStudentLists < ActiveRecord::Migration[5.1]
  def change
    create_table :student_lists do |t|
      t.string :name
      t.json :query

      t.timestamps
    end
  end
end
