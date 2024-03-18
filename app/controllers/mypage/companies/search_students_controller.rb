class Mypage::Companies::SearchStudentsController < Mypage::MypageController
  before_action :set_company

  def index
    @search_student = SearchStudent.new
    @students = Student.all.page(params[:page]).per(32)
    @new_students = @students.order(created_at: :desc).limit(4)
    @has_condition = params.key?(:univ) || params.key?(:commit) || params.key?(:business_type)

    if !@has_condition && @new_students.present?
      @new_students.each do |n|
        @students = @students.where.not(id: n)
      end
    end

    if params.key?(:keyword) && params[:keyword].present?
      @keyword = params[:keyword]
      @univ_name = University.names_with_univ[@keyword.to_sym]
      @students = @students.where(
        'nickname like :keyword
        or university like :univ_name
        or depart like :keyword
        or depart_detail like :keyword
        or id IN (SELECT id from reports where sheet like :keyword)',
        keyword: "%#{Student.sanitize_sql_like(@keyword)}%", univ_name: @univ_name
      )
    end

    if params.key?(:commit)
      if params[:search_student][:bunri] == 'true'
        @students = @students.where(bunri: true)
      elsif params[:search_student][:bunri] == 'false'
        @students = @students.where(bunri: false)
      end

      if params[:search_student][:graduate].present?
        @students = @students.where(graduation_year: params[:search_student][:graduate])
      end

      if params[:search_student][:communication] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_1 >= 4)")
      end
      if params[:search_student][:chalenge] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_2 >= 4)")
      end
      if params[:search_student][:commit] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_3 >= 4)")
      end
      if params[:search_student][:leader] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_4 >= 4)")
      end
      if params[:search_student][:teamwork] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_5 >= 4)")
      end
      if params[:search_student][:logical] == '1'
        @students = @students.where("id IN (SELECT student_id from student_abilities WHERE ability_6 >= 4)")
      end
      if params[:search_student][:toeic] != ''
        @students = @students.where('toeic_score >= ?', params[:search_student][:toeic])
      end

      if params[:search_student][:univ] == '0'
        @students = @students.where('university IN (?) ', University.soukei)
      elsif params[:search_student][:univ] == '1'
        @students = @students.where('university IN (?) ', University.march)
      elsif params[:search_student][:univ] == '2'
        @students = @students.where('university = ? ', 791)
      end

      if params[:search_student][:business_type].present?
        @students = @students.where('industry_1 = ? or industry_3 = ? or industry_3 = ?', params[:search_student][:business_type], params[:search_student][:business_type], params[:search_student][:business_type])
      end
      @search_student.bunri = params[:search_student][:bunri]
      @search_student.graduate = params[:search_student][:graduate]
      @search_student.communication = params[:search_student][:communication]
      @search_student.chalenge = params[:search_student][:chalenge]
      @search_student.commit = params[:search_student][:commit]
      @search_student.teamwork = params[:search_student][:teamwork]
      @search_student.leader = params[:search_student][:leader]
      @search_student.logical = params[:search_student][:logical]
      @search_student.toeic = params[:search_student][:toeic]
      @search_student.univ = params[:search_student][:univ]
      @search_student.business_type = params[:search_student][:business_type]

    end


    add_breadcrumb 'トップ', '/'
    add_breadcrumb '学生を探す', mypage_company_search_students_path

  end

  def show
    @student = Student.find(params[:id])
    @reports = Report.where(student_id: params[:id])
    @student_ability = StudentAbility.find_by(student_id: params[:id])

    add_breadcrumb 'トップ', '/'
    add_breadcrumb '学生を探す', mypage_company_search_students_path
    add_breadcrumb '学生詳細'

  end

  def favorite
    @favorite = Favorite.new
    @favorite.company_id = current_user.company.id
    @favorite.student_id = params[:id]
    @favorite.direction = 0
    unless @favorite.save
      redirect_to mypage_company_search_student_path(@favorite.student_id), alert: 'お気に入り登録に失敗しました'
      return
    end
    redirect_to mypage_company_search_student_path(@favorite.student_id), notice: 'お気に入り登録しました'
  end

  def favorites
    @favorites = Favorite.where(company_id: current_user.company.id)
  end

  def cancel
    @favorite = Favorite.find_by("company_id = ? AND student_id = ?", current_user.company.id, params[:id])
    unless @favorite.destroy
      redirect_to mypage_company_search_student_path(@favorite.student_id), alert: 'お気に入りの削除に失敗しました'
      return
    end
    redirect_to mypage_company_search_student_path(@favorite.student_id), notice: 'お気に入りを削除しました'
  end

  def offer
    @offer = Offer.new(offer_params)
    @offer.company_id = current_user.company.id
    @offer.student_id = params[:id]
    @offer.project_id = Project.find_by(company_id: current_user.company.id).id
    unless @offer.save
      redirect_to mypage_company_search_student_path(@offer.student_id), alert: '更新に失敗しました。オファータイプ、オファー内容を入力してください'
      return
    else
      redirect_to mypage_company_search_student_path(@offer.student_id), notice: 'オファーの登録が完了しました'
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_review_params
    params.require(:company_review).permit(:review_type, :file)
  end

  def offer_params
    params.require(:offer).permit(:offer_type, :description, :closing_date)
  end

  def search_params
    params.require(:search_student).permit(:bunri, :graduate, :communication, :chalenge, :commit, :teamwork, :leader, :logical, :toeic, :univ, :business_type)
  end

end
