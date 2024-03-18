class AddGroupChatIdToConsultations < ActiveRecord::Migration[5.2]
  def change
    add_reference :consultations, :group_chat, index: true
  end
end
