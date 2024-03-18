class Mypage::Companies::EventDraftsController < Mypage::MypageController
  #load_and_authorize_resource
  layout 'mypage_company', only: [:new, :edit, :update]
  before_action :set_company, only: [:new, :edit, :create]
  before_action :set_draft, only: [:show, :edit, :update, :destroy, :confirm, :approve, :reject, :preview]

  def show
    redirect_to edit_mypage_company_event_draft_path(@event)
  end

  def new
    @eventcount = Event.where(company_id: @company.id).count
    if @eventcount > 7
      flash[:notice] = "イベント告知ページはすでに上限数を超えてます"
      redirect_to mypage_root_path
    end
    @event = Event.new

  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb '編集'
  end

  def create
    @event = Event.new(event_draft_params)
    @event.status = Event::E_NEW
    @event.company_id = @company.id

    if @event.save
      redirect_to edit_mypage_company_event_draft_path(@event,@company), notice: 'プロジェクトを下書き保存しました'
    else
      render :new
    end
  end

  def update
    @event.attributes = event_draft_params
    @event.status = params[:submit] ? Event::E_OPEN : Event::E_EDIT
    @event.company_id = current_user.company.id

    if params.key?(:preview)
      if @event.valid?(:publish)
        render_preview(@event)
      else
        redirect_to edit_mypage_company_event_draft_path(@event), notice: '全ての項目を入力した後にプレビュー表示ができます'
      end
    else
      if (params.key?(:submit) ? @event.valid?(:publish) : true) && @event.save
        if params.key?(:submit)
          ##AdminMailer.project_submitted(@draft).deliver
          redirect_to mypage_company_path, notice: 'イベントページを公開しました。'
        else
          redirect_to edit_mypage_company_event_draft_path(@event), notice: 'イベント告知ページを下書き保存しました'
        end
      else
        @editmanu = 0
        @event.image.cache! if @event.image.present?
        redirect_to edit_mypage_company_event_draft_path(@event), alert: '全ての項目を入力し申請してください'
      end
    end
  end

  def destroy
    @draft.destroy
    redirect_to admin_projects_path, notice: 'イベント告知ページを削除しました'
  end

  def confirm
    render :confirmed if @event.status != Event::E_OPEN
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
    render_preview(@event)
  end

  private

  def set_draft
    @event = Event.find(params[:id])
  end

  def set_company
    @company = current_user.company
  end

  def event_draft_params
    params.require(:event).permit(
    :title, :name, :image, :event_type, :start, :end, :description, :capacity, :prefecture_id, :address, :selection
    )
  end

  def render_preview(event)
    @event = event.build_event(Event.new)
    @event.end = event.end
    @event.status = Event::E_OPEN
    @company = Company.find(@event.company_id)
    @otherevent = Event.where(company_id: @event.company_id, status: 4)
    response.headers['X-XSS-Protection'] = '0'
    render file: 'mypage/companies/events/show', layout: 'event'
  end
end
