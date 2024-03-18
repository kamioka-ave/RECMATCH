class PublicMessagesController < ApplicationController


  def create
    @message = PublicMessage.new(public_message_params)
    unless @message.save
      redirect_back fallback_location: root_path, alert: @message.errors.full_messages
    else
      redirect_back fallback_location: root_path, notice: "メッセージを送信しました"
    end
  end

  private

  def public_message_params
    params.require(:public_message).permit(
      :name, :email, :phone, :description
    )
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
