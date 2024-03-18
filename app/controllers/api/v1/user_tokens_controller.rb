class Api::V1::UserTokensController < Api::V1::ApiController
  before_action :authenticate_user!

  def create
    user_token = current_user.user_tokens.find_or_initialize_by user_token_params
    if user_token.save
      cookies.signed[:device_token] = user_token.device_token
      render json: user_token, status: :created
    else
      render errors: user_token.errors, status: 400
    end
  end

  private

  def user_token_params
    params.require(:user_token).permit(:device_token)
  end
end
