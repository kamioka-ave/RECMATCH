class Admin::AdminController < ActionController::Base
  include CanCan::ControllerAdditions
  include Errors

  protect_from_forgery with: :reset_session
  before_action :authenticate_admin!, :setup_commons, :restrict_remote_ip
  layout 'admin'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to access_denied_admin_pages_path
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_admin)
  end

  private

  def setup_commons
    @project_review_count = Project.where.not(status: Project::S_ACTIVE).count
    @company_tasks_count = Company.where.not(status: Company::S_ACTIVE).count
    @event_review_count = Event.where.not(status: Event::E_OPEN).count
    @default_company = Company.first
  end

  def restrict_remote_ip
    #if Rails.env.production? && !Settings.admin.ips.split(',').include?(request.remote_ip)
    #  render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    #end
  end
end
