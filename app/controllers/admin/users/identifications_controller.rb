class Admin::Users::IdentificationsController < Admin::AdminController
  before_action :set_user

  def new
    @identification = Identification.new

    add_breadcrumb 'ダッシュボード', admin_root_path
    if @user.has_role?(:student)
      add_breadcrumb '学生一覧', admin_students_path
      add_breadcrumb @user.student.full_name, admin_student_path(@user.student)
    else
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @user.company.name, admin_company_path(@user.company)
    end
    add_breadcrumb '本人確認書類の登録'
  end

  def edit
    @identification = @user.identification

    add_breadcrumb 'ダッシュボード', admin_root_path
    if @user.has_role?(:student)
      add_breadcrumb '学生一覧', admin_students_path
      add_breadcrumb @user.student.full_name, admin_student_path(@user.student)
    else
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @user.company.name, admin_company_path(@user.company)
    end
    add_breadcrumb '本人確認書類の編集'
  end

  def create
    @identification = Identification.new(identification_params)
    @identification.user_id = @user.id

    begin
      if @user.has_role?(:student)
        student = @user.student
        ActiveRecord::Base.transaction do
          @identification.save!

          if student.status != Student::S_IN_REVIEW
            student.update!(status: Student::S_IN_REVIEW)
          end
        end
        #AdminMailer.student_submitted(student).deliver_later
        redirect_to admin_student_path(student), notice: '本人確認書類を登録しました'
      else
        @identification.save!
        redirect_to admin_company_path(@user.company), notice: '本人確認書類を登録しました'
      end
    rescue
      @identification.driver_license1.cache! if @identification.driver_license1.present?
      @identification.driver_license2.cache! if @identification.driver_license2.present?
      @identification.passport1.cache! if @identification.passport1.present?
      @identification.passport2.cache! if @identification.passport2.present?
      @identification.resident_register.cache! if @identification.resident_register.present?
      @identification.resident_register_back.cache! if @identification.resident_register_back.present?
      @identification.mypage_number1.cache! if @identification.mypage_number1.present?
      @identification.public_receipt1.cache! if @identification.public_receipt1.present?
      @identification.public_receipt2.cache! if @identification.public_receipt2.present?
      @identification.others1.cache! if @identification.others1.present?
      @identification.others1_back.cache! if @identification.others1_back.present?
      @identification.others2.cache! if @identification.others2.present?
      render :new
    end
  end

  def update
    @identification = @user.identification
    history = IdentificationHistory.new_with_identification(@identification)
    @identification.attributes = identification_params

    if @identification.valid?
      if @identification.changed?
        if @identification.save_history.to_i != 0
          @identification.revision += 1
          ActiveRecord::Base.transaction do
            history.save!
            @identification.save!
          end
        else
          @identification.save!(touch: false)
        end
      end

      if @user.has_role?(:student)
        redirect_to admin_student_path(@user.student), notice: '本人確認書類を更新しました'
      else
        redirect_to admin_company_path(@user.company), notice: '本人確認書類を更新しました'
      end
    else
      @identification.driver_license1.cache! if @identification.driver_license1.present?
      @identification.driver_license2.cache! if @identification.driver_license2.present?
      @identification.passport1.cache! if @identification.passport1.present?
      @identification.passport2.cache! if @identification.passport2.present?
      @identification.resident_register.cache! if @identification.resident_register.present?
      @identification.resident_register_back.cache! if @identification.resident_register_back.present?
      @identification.mypage_number1.cache! if @identification.mypage_number1.present?
      @identification.public_receipt1.cache! if @identification.public_receipt1.present?
      @identification.public_receipt2.cache! if @identification.public_receipt2.present?
      @identification.others1.cache! if @identification.others1.present?
      @identification.others1_back.cache! if @identification.others1_back.present?
      @identification.others2.cache! if @identification.others2.present?
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def identification_params
    params.require(:identification).permit(
      :user_id, :note, :identification_type, :driver_license1, :driver_license2, :passport1, :passport2,
      :resident_register, :resident_register_back, :mypage_number1, :public_receipt1, :public_receipt2, :others1, :others1_back, :others2, :driver_license1_cache,
      :driver_license2_cache, :passport1_cache, :passport2_cache, :resident_register_cache, :resident_register_back_cache, :mypage_number1_cache,
      :public_receipt1_cache, :remove_public_receipt1, :public_receipt2_cache, :remove_public_receipt2,
      :others1_cache, :others1_back_cache, :others2_cache, :save_history
    )
  end
end
