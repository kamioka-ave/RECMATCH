class AddIsLeaveToProfiles < ActiveRecord::Migration[4.2]
  def up
    add_column :profiles, :is_leave, :boolean, null: false, default: false
  end

  def down
    remove_column :profiles, :is_leave
  end
end
