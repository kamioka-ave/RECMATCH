class AddGroupChatToCompanySupporterMessage < ActiveRecord::Migration[5.1]
  def change
    add_reference :company_supporter_messages, :group_chat, foreign_key: true
  end
end
