class AddConfirmationTokenToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :confirmation_token, :string
    add_column :admins, :confirmed_at, :datetime
    add_column :admins, :confirmation_sent_at, :datetime
    add_column :admins, :unconfirmed_email, :string
    add_column :admins, :failed_attempts, :integer, default: 0, null: false
    add_column :admins, :unlock_token, :string
    add_column :admins, :locked_at, :datetime
  end
end
