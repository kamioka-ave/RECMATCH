class AddTrialsToSmsAuths < ActiveRecord::Migration[4.2]
  def up
    add_column :sms_auths, :trials, :integer, default: 0, null: false
    change_column_default :sms_auths, :authorized, false
  end

  def down
    remove_column :sms_auths, :trials
  end
end
