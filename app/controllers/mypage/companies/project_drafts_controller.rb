class Mypage::Companies::ProjectDraftsController < Mypage::MypageController
  #load_and_authorize_resource
  layout 'mypage_company', only: [:show, :edit]
  before_action :set_company, only: [:show, :new, :edit, :create]
  before_action :set_draft, only: [:show, :edit, :update, :destroy, :confirm, :approve, :reject, :preview]

  def show
    if @draft.blank?
      @draft = ProjectDraft.new
    end
  end

  def new
    if ProjectDraft.find_by(company_id: @company.id)
      flash[:notice] = "採用募集ページはすでに作成されています"
      redirect_to mypage_root_path
    end
    @draft = ProjectDraft.new
    #@draft.company_presidents.build

    @companies = Company.includes(:projects).select do |c|
      if c.projects.empty?
        true
      else
        c.projects.select { |p| p.created_at < 1.year.ago }
      end
    end

  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb '編集'
    @editmanu = 0
  end

  def create
    @draft = ProjectDraft.new(project_draft_params)
    @draft.status = ProjectDraft::S_NEW
    @draft.company_id = @company.id

    if @draft.save
      redirect_to edit_mypage_company_project_draft_path(@draft,@company), notice: 'プロジェクトを下書き保存しました'
    else
      render :new
    end
  end

  def update
    if @draft.blank?
      @draft = ProjectDraft.new
    end
    @draft.attributes = project_draft_params
    @draft.status = params[:submit] ? ProjectDraft::S_ACTIVE : ProjectDraft::S_EDIT
    @draft.company_id = current_user.company.id
    @draft.number_hired = current_user.company.employees

    if params.key?(:preview)
      if @draft.valid?(:publish)
        render_preview(@draft)
      else
        redirect_to edit_mypage_company_project_draft_path(@draft), notice: '全ての必須項目を入力した後にプレビュー表示ができます'
      end
    else
      if (params.key?(:submit) ? @draft.valid?(:publish) : true) && @draft.save
        if params.key?(:submit) && @draft.publish!
          ##AdminMailer.project_submitted(@draft).deliver
          redirect_to mypage_company_path, notice: '企業ページを公開しました'
        else
          redirect_to mypage_company_project_drafts_path, notice: '企業ページを下書き保存しました'
        end
      else
        @editmanu = 0
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
    redirect_to mypage_root_path, notice: '採用募集ページを削除しました'
  end

  def confirm
    render :confirmed if @draft.status != ProjectDraft::DS_SUBMITTED
  end

  def approve
    @draft.assign_attributes(project_draft_params)
    @draft.publish!
    redirect_to admin_projects_path, notice: "#{@draft.name}を承認しました"
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
    @draft = ProjectDraft.find_by(company_id: current_user.company.id)
  end

  def set_company
    @company = current_user.company
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
