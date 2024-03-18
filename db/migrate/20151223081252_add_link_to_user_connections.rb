class AddLinkToUserConnections < ActiveRecord::Migration[4.2]
  def up
    add_column :user_connections, :link, :string
  end

  def down
    remove_column :user_connections, :link
  end
end
