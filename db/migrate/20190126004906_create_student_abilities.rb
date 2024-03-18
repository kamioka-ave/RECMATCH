class CreateStudentAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :student_abilities do |t|
      t.integer :student_id
      t.integer :admin_id
      t.decimal :ability_1, :precision => 2, :scale => 1
      t.decimal :ability_2, :precision => 2, :scale => 1
      t.decimal :ability_3, :precision => 2, :scale => 1
      t.decimal :ability_4, :precision => 2, :scale => 1
      t.decimal :ability_5, :precision => 2, :scale => 1
      t.decimal :ability_6, :precision => 2, :scale => 1

      t.timestamps
    end
  end
end
