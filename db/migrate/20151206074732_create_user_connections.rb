class CreateUserConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :user_connections do |t|
      t.integer :user_id
      t.string :access_token
      t.string :display_name
      t.string :expire_time
      t.string :image_url
      t.string :profile_url
      t.string :provider_id
      t.string :provider_user_id
      t.integer :rank
      t.string :refresh_token
      t.string :secret

      t.timestamps null: false
    end

    add_index :user_connections, :user_id
  end
end
