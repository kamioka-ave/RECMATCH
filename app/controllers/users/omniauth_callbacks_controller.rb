class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    connect('FacebookConnectionFactory', 0)
  end

  def twitter
    unless request.delete?
      connect('TwitterConnectionFactory', 1)
    end
  end

  private

  def connect(connection_factory, rank)
    auth = request.env['omniauth.auth']

    if current_user
      connection = Object.const_get(connection_factory).create(auth, rank, current_user.id)
      connection.save
      redirect_to mypage_user_connections_path, notice: "#{connection.provider_id}と接続しました"
      return
    end

    connection = UserConnection.find_by(provider_id: auth.provider, provider_user_id: auth.uid)
    if connection.nil?
      connection = Object.const_get(connection_factory).create(auth, rank).attributes
      connection['email'] = auth.extra.raw_info.email
      session['user_connection'] = connection
      redirect_to new_user_registration_url
      return
    end

    @user = connection.user

    sign_in_and_redirect @user, event: :authentication
  end
end
