class CreateAdminStudentsDisplays < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_students_displays do |t|
      t.integer :admin_id
      t.boolean :identifier, default: true, null: false
      t.boolean :full_name, default: true, null: false
      t.boolean :birth_on, default: true, null: false
      t.boolean :birth_on_ja, default: true, null: false
      t.boolean :status, default: true, null: false
      t.boolean :student_created_at, default: false, null: false
      t.boolean :applied_at, default: false, null: false
      t.boolean :approved_at, default: false, null: false
      t.boolean :rejected_at, default: false, null: false
      t.boolean :waiting_activation_at, default: false, null: false
      t.boolean :activated_at, default: false, null: false
      t.boolean :created_days, default: true, null: false
      t.boolean :applied_days, default: true, null: false
      t.boolean :locked_at, default: true, null: false
      t.boolean :lock_reason, default: true, null: false
      t.boolean :lost_orders, default: true, null: false
      t.boolean :identification_note, default: true, null: false

      t.timestamps
    end

    Admin.all.each do |admin|
      Admin::StudentsDisplay.create!(
        admin_id: admin.id
      )
    end
  end
end
