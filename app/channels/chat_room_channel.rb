class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  @new_message = ChatMessage.new(student_id: data["s_id"], company_id: data["c_id"], direct: data["dir"], description: data["desc"])
    if @new_message.save
      ActionCable.server.broadcast 'chat_room_channel', data
    end
  end
end
