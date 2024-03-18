class Mypage::ReportsController < Mypage::MypageController
  before_action :report_params, only: [:create, :update]
  before_action :set_report, only: [:show, :destroy, :edit, :update]
  before_action :set_reports, only: [:create, :index]
  layout 'mypage_student'

  def index
    if Report.maximum(:id).nil?
      @maxid = 1
    else
      @maxid = Report.maximum(:id) + 1
    end
  end

  def show; end

  def new
    @report = Report.new(user_id: current_user.id)
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.student_id = current_user.student.id
    if @report.save
      redirect_to mypage_reports_path, notice: 'エントリーシートを登録しました'
    else
      render :new
    end
  end

  def edit
    render :new
  end

  def update
    unless @report.update(report_params)
      render :new
    else
      redirect_to mypage_reports_path, notice: 'エントリーシートを更新しました'
    end
  end

  def destroy
    @report.destroy!
    redirect_to mypage_reports_path, notice: 'エントリーシートを削除しました'
  end

  private

  def set_report
    @report = Report.find_by!(id: params[:id], user_id: current_user.id)
  end

  def set_reports
    @q = Report.where(user_id: current_user.id)
               .order('id ASC')
               .ransack(params[:q])
        @reports = @q.result.page(params[:page]).per(10)
  end

  def report_params
    params.require(:report).permit(
          :report_type, :report_type_name, :sheet
        )
  end
end
