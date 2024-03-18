class CreateSchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :schedules do |t|
      t.integer :project_id
      t.string :title
      t.text :description
      t.date :date

      t.timestamps null: false
    end
  end
end
