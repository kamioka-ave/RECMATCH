class Mypage::UserConnectionsController < Mypage::MypageController
  layout 'mypage'

  def index; end

  def delete
    provider = params[:provider]
    connection = UserConnection.find_by(user_id: current_user.id, provider_id: provider)
    connection.destroy
    redirect_to mypage_user_connections_path, notice: "#{provider}から切断しました"
  end
end
