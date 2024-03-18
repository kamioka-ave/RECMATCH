class Admin::Students::IdentificationRecordsController < Admin::AdminController
  before_action :set_student
  before_action :set_student_identification_record, only: [:show, :edit, :update, :destroy]

  def show
    @document_names = Hash[*IdentificationDocument.all.pluck(:id, :name).flatten.map(&:to_s)]
    @document_ids = @record.identification_documents.pluck(:id)
    render(
      pdf: 'identification_record',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  def new
    @record = StudentIdentificationRecord.new
    @record.student = @student
    @record.identifier = @student.identifier
    @record.name = @student.full_name
    @record.zip_code = @student.zip_code
    @record.address = @student.full_address
    @record.birth_on = @student.birth_on
    @record.identified_on = @student.identified_at.to_date if @student.identified_at.present?
    @record.reason = StudentIdentificationRecord::R_OPEN_ACCOUNT
    @record.is_completion_by_mail = true
    @record.supplement_confirm_way = StudentIdentificationRecord::W_WEB
    @record.confirmer = @student.approver
    @record.creator = @student.identifier
    @record.receptor = @student.identifier
    @record.build_identification_documents!(@student.user.identification)
    build_breadcrumb { add_breadcrumb('本人確認記録簿の登録') }
  end

  def edit
    build_breadcrumb { add_breadcrumb('本人確認記録簿の編集') }
  end

  def create
    @record = StudentIdentificationRecord.new(student_identification_record_params)

    if @record.save
      redirect_to admin_student_path(@student), notice: '本人確認記録簿を登録しました'
    else
      build_breadcrumb { add_breadcrumb('本人確認記録簿の登録') }
      render :new
    end
  end

  def update
    if @record.update(student_identification_record_params)
      redirect_to admin_student_path(@student), notice: '本人確認記録簿を更新しました'
    else
      build_breadcrumb { add_breadcrumb('本人確認記録簿の編集') }
      render :edit
    end
  end

  def destroy
    @record.destroy
    redirect_to admin_student_path(@student), notice: '本人確認記録簿を削除しました'
  end

  private

  def build_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    yield
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_record
    @product = Product.find(params[:id])
  end

  def set_student_identification_record
    @record = StudentIdentificationRecord.find(params[:id])
  end

  def student_identification_record_params
    params.require(:student_identification_record).permit(
      :student_id, :identified_on, :identifier_id, :recorder_id, :name, :zip_code, :address, :birth_on,
      :reason, :reason_note, :supplement1_number, :supplement1_has_number, :supplement1_issued_on,
      :supplement1_limit_on, :supplement2_number, :supplement2_has_number, :supplement2_issued_on,
      :supplement2_limit_on, :supplement_confirm_way, :supplement_confirm_way_note, :completed_on,
      :is_completion_by_mail, :is_completion_by_others, :completion_by_others_note, :confirmer_id, :creator_id,
      :receptor_id, :document_b_others_note, :document_c_others_note, :complement_document_others_note,
      identification_number_ids: [], identification_document_a_ids: [], identification_document_b_ids: [],
      identification_document_c_ids: [], identification_document_d_ids: [], identification_complement_document_ids: []
    )
  end
end
