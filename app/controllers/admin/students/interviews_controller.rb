class Admin::Students::InterviewsController < Admin::AdminController
  before_action :set_interview, only: [:edit, :update, :confirm, :approve, :reject]

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    add_breadcrumb '学生適合性確認の編集'
  end

  def update
    history = StudentInterviewHistory.new_with_interview(@interview)
    @interview.attributes = student_params

    if @interview.valid?
      if @interview.changed?
        @interview.revision += 1
        ActiveRecord::Base.transaction do
          history.save!
          @interview.save!
        end
      end
      redirect_to admin_student_path(@student), notice: '学生適合性確認を更新しました'
    else
      render :edit
    end
  end

  def confirm
    @draft = @interview.draft.reify
  end

  def approve
    @dependencies = @interview.draft.draft_publication_dependencies

    if @dependencies.empty?
      @interview.draft.publish!
      StudentMailer.student_interview_approved(@student).deliver_later
      redirect_to admin_student_path(@student), notice: '更新依頼を承認しました'
    else
      redirect_to :back, error: '承認できませんでした'
    end
  end

  def reject
    @dependencies = @interview.draft.draft_publication_dependencies

    if @dependencies.empty?
      @interview.draft.revert!
      StudentMailer.student_interview_rejected(@student, student_params[:comment]).deliver_later
      redirect_to admin_student_path(@student), notice: '更新依頼を却下しました'
    else
      redirect_to :back, error: '却下できませんでした'
    end
  end

  private

  def set_interview
    @student = Student.find(params[:student_id])
    @interview = @student.interview
  end

  def student_params
    params.require(:student_interview).permit(
      :income_resource, :income_resource_other, :income, :assets, :has_experience,
      :exp_stock, :exp_bond, :exp_trust_fund, :exp_commodity_futures, :exp_foreign_currency_saving,
      :exp_foreign_exchange, :exp_account, :capital_character, :capital_character_note, :purpose, :purpose_note, :comment,
      :how_to_know, student_interest_ids: []
    )
  end
end