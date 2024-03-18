class Admin::CancelReasonQuestionsController < Admin::AdminController
  before_action :set_cancel_reason_question, only: [:edit, :update, :destroy]

  def index
    @cancel_reason_questions = CancelReasonQuestion.all
  end

  def new
    @cancel_reason_question = CancelReasonQuestion.new
  end

  def edit; end

  def create
    @cancel_reason_question = CancelReasonQuestion.new(cancel_reason_question_params)

    if @cancel_reason_question.save
      redirect_to admin_cancel_reason_questions_path, notice: 'アンケート項目を追加しました'
    else
      render :new
    end
  end

  def update
    if @cancel_reason_question.update(cancel_reason_question_params)
      redirect_to admin_cancel_reason_questions_path, notice: 'アンケート項目を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @cancel_reason_question.destroy
    redirect_to admin_cancel_reason_questions_path, notice: 'アンケート項目を削除しました'
  end

  private

  def set_cancel_reason_question
    @cancel_reason_question = CancelReasonQuestion.find(params[:id])
  end

  def cancel_reason_question_params
    params.require(:cancel_reason_question).permit(:name, :rank)
  end
end
