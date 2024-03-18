class ApplicationController < ActionController::Base
  include Errors


  protect_from_forgery with: :exception

  before_action :set_variant, :check_commons, :store_location

  http_basic_authenticate_with name: 'rec-user', password: 'rec20180831' if Rails.env.staging?

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token

  private

  def check_commons

    if user_signed_in?
      @messages_count = current_user.mailbox.inbox({read: false}).count
    end
  end

  def set_variant
    if browser.platform.ios? || browser.platform.android? || browser.platform.windows_phone?
      request.variant = :mobile
    else
      request.variant = :pc
    end

    #request.variant = :mobile if Rails.env.development?
  end

  def after_confirmation_path_for(resource_name, resource)
    mypage_root_path
  end

  def after_sign_in_path_for(resource)
    if resource.kind_of?(Admin)
      admin_root_path
    else
      if session[:previous_url] == root_path
        mypage_root_path
      else
        session[:previous_url] || mypage_root_path
      end
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      admin_root_path
    else
      super
    end
  end

  def store_location
    if (request.fullpath !~ Regexp.new('\\A/users.*\\z') &&
      request.fullpath != '/recmatchadmin20180830/sign_in' &&
      request.fullpath != '/recmatchadmin20180830/sign_up' &&
      request.fullpath != '/recmatchadmin20180830/edit' &&
      !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def handle_invalid_authenticity_token
    render file: 'pages/invalid_authnticity_token'
  end
end
