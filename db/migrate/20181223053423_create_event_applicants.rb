class CreateEventApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :event_applicants do |t|
      t.integer :event_id
      t.integer :student_id
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
