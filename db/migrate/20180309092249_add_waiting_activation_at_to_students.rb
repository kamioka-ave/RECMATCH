class AddWaitingActivationAtToStudents < ActiveRecord::Migration[5.1]
  def up
    add_column :students, :rejected_at, :datetime, after: :applied_at
    add_column :students, :waiting_activation_at, :datetime, after: :approved_at

    Student.record_timestamps = false
    Student.all.each do |i|
      changed_at = i.status_changed_at(Student::S_REJECTED)
      if changed_at != nil
        i.rejected_at = changed_at
        i.save!(validate: false)
      end

      changed_at = i.status_changed_at(Student::S_WAITING_ACTIVATION)
      if changed_at != nil
        i.waiting_activation_at = changed_at
        i.save!(validate: false)
      end
    end
    Student.record_timestamps = true
  end

  def down
    remove_column :students, :rejected_at
    remove_column :students, :waiting_activation_at
  end
end
