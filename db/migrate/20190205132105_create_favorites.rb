class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :company_id
      t.integer :student_id
      t.integer :direction

      t.timestamps
    end
  end
end
