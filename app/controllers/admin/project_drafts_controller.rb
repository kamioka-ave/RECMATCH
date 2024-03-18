class Admin::ProjectDraftsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_draft, only: [:edit, :update, :destroy, :confirm, :approve, :reject, :preview]

  def new
    @draft = ProjectDraft.new
    @draft.company_presidents.build

    @companies = Company.includes(:projects).select do |c|
      if c.projects.empty?
        true
      else
        c.projects.select { |p| p.created_at < 1.year.ago }
      end
    end

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb '作成'
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb '編集'
  end

  def create
    @draft = ProjectDraft.new(project_draft_params)
    @draft.status = ProjectDraft::DS_DRAFT
    @draft.admin_id = current_admin.id

    if @draft.save
      redirect_to edit_admin_project_draft_path(@draft), notice: 'プロジェクトを下書き保存しました'
    else
      render :new
    end
  end

  def update
    #@draft.project_draft_categories.clear
    @draft.attributes = project_draft_params
    @draft.status = params[:submit] ? ProjectDraft::S_JUDGE : ProjectDraft::S_EDIT
    @draft.proposal_id = current_admin.id
    #@draft.authorizer_id = nil

    if params.key?(:preview)
      render_preview(@draft)
    else
      if (params.key?(:submit) ? @draft.valid?(:publish) : true) && @draft.save
        if params.key?(:submit)
          #AdminMailer.project_submitted(@draft).deliver
          redirect_to admin_projects_path, notice: 'プロジェクトの承認依頼を行いました'
        else
          redirect_to admin_projects_path, notice: 'プロジェクトを下書き保存しました'
        end
      else
        @draft.image.cache! if @draft.image.present?
        @draft.president_image.cache! if @draft.president_image.present?
        @draft.contract_before.cache! if @draft.contract_before.present?
        @draft.law_notification.cache! if @draft.law_notification.present?
        @draft.stamp.cache! if @draft.stamp.present?
        @draft.contract_attachment.cache! if @draft.contract_attachment.present?
        render :edit
      end
    end
  end

  def destroy
    @draft.destroy
    redirect_to admin_projects_path, notice: 'プロジェクトを削除しました'
  end

  def confirm
    render :confirmed if @draft.status = !ProjectDraft::S_JUDGE
  end

  def approve

    @draft.assign_attributes(project_draft_params)

    if @draft.update(status: ProjectDraft::S_ACTIVE)
      @draft.publish!
      redirect_to admin_projects_path, notice: "#{@draft.name}を承認しました"
    end

  end

  def reject
    @draft.assign_attributes(project_draft_params)

    if @draft.save
      #AdminMailer.project_rejected(@draft, project_draft_params[:comment]).deliver_later
      redirect_to admin_projects_path, notice: "#{@draft.name}を差戻しました"
    else
      redirect_to confirm_admin_project_draft_path(@draft), error: "#{@draft.name}を差戻しできませんでした"
    end
  end

  def preview
    render_preview(@draft)
  end

  private

  def set_draft
    @draft = ProjectDraft.find(params[:id])
  end

  def project_draft_params
    params.require(:project_draft).permit(
    :name,:image, :interview_movie, :president_image, :president_description, :short_description, :description, :company_info,
    :number_hired, :salary, :process_selection, :selection_condition, :entry_closed, :student_assumption, :recruit_kind,
    :duty_station, :new_salary, :allowance, :raise_salary, :reward, :holiday, :insurance, :welfare_program, :company_event,
    :sex_ratio, :trial_period, :other_welfare, :retired_ratio, :sex_ratio_hired, :continuous, :old, :training, :vacation,
    :childcare, :recruit_univ, :univ_depart, :start_at, :end_at
    )
  end

  def render_preview(draft)
    @project = draft.build_project(Project.new)
    @company = Company.find(@project.company_id)
    @events = Event.where(company_id: @project.company_id, status: 0)
    response.headers['X-XSS-Protection'] = '0'
    render file: 'mypage/companies/projects/show', layout: 'project'
  end
end
