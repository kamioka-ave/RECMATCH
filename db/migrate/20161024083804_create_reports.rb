class CreateReports < ActiveRecord::Migration[4.2]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :student_id
      t.integer :report_type
      t.integer :status, default: 0, null: false
      t.integer :version
      t.integer :balance
      t.text :sheet, :limit => 1000

      t.timestamps null: false
    end
  end
end
