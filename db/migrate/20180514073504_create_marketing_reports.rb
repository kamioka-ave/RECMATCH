class CreateMarketingReports < ActiveRecord::Migration[5.1]
  def change
    create_table :marketing_reports do |t|
      t.date :date, null: false
      t.integer :user_increase, default: 0, null: false
      t.integer :student_increase, default: 0, null: false
      t.integer :student_new_increase, default: 0, null: false
      t.integer :student_in_review_increase, default: 0, null: false
      t.integer :student_activated_increase, default: 0, null: false

      t.timestamps
    end

    add_index :marketing_reports, :date, unique: true
    drop_table :featured_projects
  end
end
