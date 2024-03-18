class CreateUserTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tokens do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.string :device_token, unique: true

      t.timestamps
    end
  end
end
