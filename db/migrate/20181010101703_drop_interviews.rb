class DropInterviews < ActiveRecord::Migration[5.2]
  def change
    drop_table :interviews
  end
end
