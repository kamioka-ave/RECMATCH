class Admin::PageDraftsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_page_draft, only: [:show, :edit, :update, :destroy, :revision, :update_revision]

  def index
    @q = PageDraft.ransack(params[:q])
    @page_drafts = @q.result.page(params[:page]).order(updated_at: :desc).per(30)
  end

  def show
    if params[:version].to_i != @page_draft.versions.last.index
      @page_draft = @page_draft.versions.select { |v| v.index == (params[:version].to_i + 1) }.first.reify
    end

    render json: @page_draft
  end

  def new
    @page_draft = PageDraft.new
  end

  def edit; end

  def create
    @page_draft = PageDraft.new(page_draft_params)

    if params[:submit]
      @page_draft.status = PageDraft::S_PUBLISHED
      @page_draft.admin_id = current_admin.id

      ActiveRecord::Base.transaction do
        @page_draft.update!(page_draft_params)
        page = build_page(@page_draft)
        page.save!
      end

      redirect_to admin_page_drafts_path, notice: "#{@page_draft.title}を公開しました"
    else
      @page_draft.status = PageDraft::S_DRAFT
      @page_draft.save!
      redirect_to admin_page_drafts_path, notice: "#{@page_draft.title}を下書き保存しました"
    end
  rescue => e
    flash[:error] = e.message
    render :new
  end

  def update
    update_params = page_draft_params

    if params[:submit]
      update_params[:status] = PageDraft::S_PUBLISHED
      update_params[:admin_id] = current_admin.id
      @page_draft.update!(update_params)

      page = build_page(@page_draft)
      page.save!

      redirect_to admin_page_drafts_path, notice: "#{@page_draft.title}を公開しました"
    else
      update_params[:status] = PageDraft::S_DRAFT
      @page_draft.update!(update_params)
      redirect_to admin_page_drafts_path, notice: "#{@page_draft.title}を下書き保存しました"
    end
  rescue => e
    flash[:error] = e.message
    render :edit
  end

  def destroy
    @page_draft.destroy
    redirect_to admin_page_drafts_path, notice: '固定ページを削除しました'
  end

  def revision; end

  def update_revision
    @page_draft = @page_draft.versions.select { |v| v.index == (params[:revision].to_i + 1) }.first.reify
    render :edit
  end

  private

  def set_page_draft
    @page_draft = PageDraft.find(params[:id])
  end

  def page_draft_params
    params.require(:page_draft).permit(
      :admin_id, :path, :page_type, :title, :head, :body, :description, :keywords, :status
    )
  end

  def build_page(page_draft)
    page = page_draft.page.present? ? page_draft.page : Page.new
    page.page_draft_id = page_draft.id
    page.path = page_draft.path
    page.page_type = page_draft.page_type
    page.title = page_draft.title
    page.head = page_draft.head
    page.body = page_draft.body
    page.description = page_draft.description
    page.keywords = page_draft.keywords
    page
  end
end
