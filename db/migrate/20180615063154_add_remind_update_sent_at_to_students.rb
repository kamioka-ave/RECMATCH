class AddRemindUpdateSentAtToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :remind_update_sent_at, :datetime, after: :change_history
  end
end
