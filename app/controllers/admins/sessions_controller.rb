class Admins::SessionsController < Devise::SessionsController
  before_action :restrict_remote_ip
  layout 'admin_login'

  private

  def restrict_remote_ip
    #if Rails.env.production? && !Settings.admin.ips.split(',').include?(request.remote_ip)
    #  render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    #end
  end
end
