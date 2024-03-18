class CreateEducations < ActiveRecord::Migration[4.2]
  def change
    create_table :educations do |t|
      t.integer :user_id
      t.string :name
      t.string :major
      t.date :graduated_on
      t.text :note

      t.timestamps null: false
    end
  end
end
