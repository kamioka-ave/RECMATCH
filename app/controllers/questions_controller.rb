class QuestionsController < ApplicationController
  before_action :setup_menu
  before_action :set_question, only: [:show, :upvote, :downvote]
  impressionist actions: [:show], unique: [:impressionable_type, :impressionable_id, :session_hash]

  def index
    @questions = Question.all
    @categories = QuestionCategory.includes(:questions).all
    @latest_questions = Question.all.order(created_at: :desc).limit(5)
    @most_viewed_questions = Question.all.order(impressions_count: :desc).limit(5)
  end

  def show; end

  def category
    @category = QuestionCategory.find(params[:id])
    @questions = Question.where(question_category_id: @category.id).page(params[:page]).per(20)
  end

  def search
    @questions = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(20)

    if params.key?(:q)
      @keyword = params[:q][:name_or_asking_or_answer_cont]
    end
  end

  def upvote
    current_session = Session.find_by(session_id: session.id)
    @voted_flg = current_session.voted_up_on?(@question) || current_session.voted_down_on?(@question)

    if @voted_flg
      @message = '既にご意見をいただいております'
    else
      @question.liked_by(current_session)
      @message = 'ご意見ありがとうございます'
    end
  end

  def downvote
    current_session = Session.find_by(session_id: session.id)
    @voted_flg = current_session.voted_up_on?(@question) || current_session.voted_down_on?(@question)

    if @voted_flg
      @message = '既にご意見をいただいております'
    else
      @question.disliked_by(current_session)
      @message = 'ご意見ありがとうございます'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def setup_menu
    @q = Question.search(params[:q])
  end
end
