class AddExpiresAtToUserTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tokens, :expires_at, :datetime
  end
end
