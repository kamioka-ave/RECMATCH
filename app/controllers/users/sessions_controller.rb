class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.student.present? && !resource.student.can_sign_in?
      sign_in(resource_name, resource)
      sign_out(resource)
      flash[:error] = 'ご入力いただいたメールアドレスとパスワードではログインできません。'
      respond_with resource, location: new_session_path(resource)
    else
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
      #current_user.check_student_ip
    end
  end

  def destroy
    user_token = UserToken.find_by(device_token: cookies.signed[:device_token])
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    user_token.destroy if signed_out && user_token
    yield if block_given?
    respond_to do |format|
      format.html { redirect_to after_sign_out_path_for(resource_name) }
      format.js
    end
  end
end
