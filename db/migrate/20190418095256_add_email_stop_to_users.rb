class AddEmailStopToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :email_stop, :boolean, after: :email
  end

  def down
    remove_column :users, :email_stop, :boolean
  end
end
