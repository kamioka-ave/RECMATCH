class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  layout 'mypage', only: [:edit, :update]

  # GET /resource/sign_up
  def new
    build_resource({})
    resource.build_profile
    set_minimum_password_length
    yield resource if block_given?

    if params.key?(:as) && params[:as] == 'company'
      @role = Role::R_COMPANY
    else
      @role = Role::R_INVESTOR
    end

    connection = session['user_connection']
    if connection
      if connection['provider_id'].downcase == 'facebook'
        self.resource.profile.name = connection['display_name']
        self.resource.email = connection['email']
      else
        self.resource.profile.name = connection['display_name']
      end

      self.resource.password = [*1..9, *'A'..'Z', *'a'..'z'].sample(8).join
      self.resource.password_confirmation = resource.password
    else
      self.resource.profile.name = '名無し'
    end

    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.password_confirmation = resource.password
    resource.terms = sign_up_params[:terms]
    @role = sign_up_params[:role_ids].to_i
    session['role'] = @role

    begin
      resource.save
    rescue ActiveRecord::RecordNotUnique
      set_flash_message(:error, 'duplicated_email') if is_flashing_format?
      respond_with resource, location: after_sign_up_path_for(resource)
      return
    rescue
      set_flash_message(:error, 'failure') if is_flashing_format?
      respond_with resource, location: after_sign_up_path_for(resource)
      return
    end

    yield resource if block_given?

    if resource.persisted?
      record_inflow(resource.id)
      #AddBigqueryUserJob.perform_later(resource.id)

      expire_data_after_sign_in!

      connection = session['user_connection']
      if connection
        connection.delete('email') if connection.key?('email')
        connection['user_id'] = resource.id
        UserConnection.create!(connection) # TODO: catch
        session.delete('user_connection')
      end

      if session.key?(:previous_url)
        session.delete(:previous_url)
      end

      Account.create!(user_id: resource.id)
      sign_in(resource)
      # set_flash_message(:notice, 'ユーザー登録が完了しました')
      flash[:notice] = 'メールを送信しました'
      respond_with(resource, location: after_sign_up_path_for(resource))
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    @headlines = Headline.all.order(created_at: :desc).limit(3)
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(
        :email, :password, :password_confirmation, :terms, :role_ids,
        profile_attributes: [:name, :company, :receive_notification]
      )
    end
  end

  def after_inactive_sign_up_path_for(resource)
    thanks_pages_path
  end

  def record_inflow(resource_id)
    if session.key?('inflow')
      inflow = Inflow.create(
        user_id: resource_id,
        ab: session['inflow']['ab'],
        referer: session['inflow']['referer'],
        segment: session['inflow']['segment']
      )

      if inflow && session['inflow'].key?('params')
        session['inflow']['params'].each do |k, v|
          if k == 'referrer'
            inflow.update(referer: v)
          elsif k != 'controller' && k != 'action' && k != 'as'
            InflowParam.create(
              inflow_id: inflow.id,
              name: k,
              value: v
            )
          end
        end
      end

      session.delete('inflow')
    end
  end
end
