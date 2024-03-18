class Api::V1::MessagesController < Api::V1::ApiController

  def show
    message = CompanySupporter::Message.find params[:id]
    seen_members = message.seen_members
    unseen_members = message.unseen_members
    render json: {seen_members: seen_members.as_json, unseen_members: unseen_members.as_json}, status: :ok
  end
end
