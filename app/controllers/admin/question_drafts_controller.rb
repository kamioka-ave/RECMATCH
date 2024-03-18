class Admin::QuestionDraftsController < Admin::AdminController
  before_action :set_question_draft, only: [:show, :edit, :update, :destroy]

  def index
    @q = QuestionDraft.includes(:question, :question_category).ransack(params[:q])
    @question_drafts = @q.result.page(params[:page]).per(100)
  end

  def show; end

  def new
    @question_draft = QuestionDraft.new
  end

  def edit; end

  def create
    tmp_params = question_draft_params
    tmp_params[:status] = params[:submit] ? QuestionDraft::S_PUBLISHED : QuestionDraft::S_DRAFT

    @question_draft = QuestionDraft.new(tmp_params)

    if @question_draft.save
      redirect_to admin_question_drafts_path, notice: params[:submit] ? '公開しました' : '下書き保存しました'
    else
      render :new
    end
  end

  def update
    tmp_params = question_draft_params
    tmp_params[:status] = params[:submit] ? QuestionDraft::S_PUBLISHED : QuestionDraft::S_DRAFT

    if @question_draft.update(tmp_params)
      redirect_to admin_question_drafts_path, notice: params[:submit] ? '公開しました' : '下書き保存しました'
    else
      render :new
    end
  end

  def destroy
    @question_draft.destroy
    redirect_to admin_question_drafts_url, notice: 'よくある質問を削除しました'
  end

  private

  def set_question_draft
    @question_draft = QuestionDraft.find(params[:id])
  end

  def question_draft_params
    params.require(:question_draft).permit(
      :question_category_id, :name, :asking, :answer, :rank, :status,
      question_draft_questions_attributes: [:id, :question_id, :_destroy]
    )
  end
end
