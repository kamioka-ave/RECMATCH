class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /users/confirmation?confirmation_token=abcdef
  def show
    confirmable = resource_class.find_first_by_auth_conditions(confirmation_token: params[:confirmation_token])
    notice = confirmable.nil? || confirmable.unconfirmed_email.nil? ? 'メール認証が完了しました' : 'メールアドレスの変更が完了しました'

    if confirmable.present? && confirmable.unconfirmed_email.present?
      email_prev = confirmable.email
    end

    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(resource)

      if email_prev.present?
        #ChangeSendGridEmailJob.perform_later(email_prev, resource.email)
      end

      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource), notice: notice }
    else
      if resource.errors.messages.present? && resource.errors.messages.has_key?(:email)
        if user_signed_in?
          redirect_to mypage_root_path
        else
          redirect_to new_user_session_path, notice: "#{resource.email}は既に登録確認済みです。ログインしてください。"
        end
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
      end
    end
  end

  def create
    if user_signed_in? && current_user.confirmed_at.nil?
      current_user.send_on_create_confirmation_instructions
    else
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    mypage_root_path
  end
end
