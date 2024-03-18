class Admin::EventsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_event, only: [:show, :fail, :abort, :applicants, :confirm, :approve, :reject]
  before_action :set_company, only: [:new, :edit, :create]

  def index
    @q = Event.unscoped.includes(:company).order('id DESC').ransack(params[:q])
    @events = @q.result.page(params[:page]).per(100)
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'イベントページ一覧'
  end

  def show
    render :confirm

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'イベントページ一覧', admin_projects_path
    add_breadcrumb @event.name
  end

  def applicants
    csv = @project.applicants_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data(
      bom + csv.encode(Encoding::UTF_8),
      filename: "applicants_p#{@project.id}.csv",
      disposition: 'attachment',
      type: 'text/csv'
    )
  end

  def new
    @eventcount = Event.where(company_id: @company.id).count
    if @eventcount > 7
      flash[:notice] = "イベント告知ページはすでに上限数を超えてます"
      redirect_to events_path
    end
    @event = Event.new

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'イベントページ一覧', admin_projects_path
    add_breadcrumb '作成'
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'イベントページ一覧', admin_projects_path
    add_breadcrumb '編集'
  end

  def create
    @draft = ProjectDraft.new(project_draft_params)
    @draft.status = ProjectDraft::DS_DRAFT
    @draft.admin_id = current_admin.id

    if @draft.save
      redirect_to edit_admin_project_draft_path(@draft), notice: 'イベントページを下書き保存しました'
    else
      render :new
    end
  end

  def update
    @draft.project_draft_categories.clear
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
          redirect_to admin_projects_path, notice: 'イベントページの承認依頼を行いました'
        else
          redirect_to admin_projects_path, notice: 'イベントページを下書き保存しました'
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
    redirect_to admin_projects_path, notice: 'イベントページを削除しました'
  end

  def confirm
    render :confirmed if @event.status = !Event::E_OPEN
  end

  def approve
    @event.assign_attributes(event_params)
    if @event.update(status: Event::E_OPEN)
      redirect_to admin_events_path, notice: "#{@event.name}を承認しました"
    end
  end

  def reject
    @event.assign_attributes(event_params)

    if @event.save
      #AdminMailer.event_rejected(@event, event_params[:comment]).deliver_later
      redirect_to admin_projects_path, notice: "#{@event.title}を差戻しました"
    else
      redirect_to confirm_admin_event_path(@event), error: "#{@event.title}を差戻しできませんでした"
    end
  end

  def preview
    render_preview(@event)
  end


  private

  def event_params
    params.require(:event).permit(
      :title, :name, :image, :event_type, :start, :end, :description, :capacity, :prefecture_id, :address, :selection, :status,
      :proposal_id, :comment
    )
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_company
    @company = current_user.company
  end
end
