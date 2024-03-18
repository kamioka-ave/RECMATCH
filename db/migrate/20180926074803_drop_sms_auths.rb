class DropSmsAuths < ActiveRecord::Migration[5.2]
  def change
    drop_table :sms_auths
  end
end
