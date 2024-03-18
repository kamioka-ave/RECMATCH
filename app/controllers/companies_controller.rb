class CompaniesController < ApplicationController
  def index
    if true
      render_404
    else
      @companies = Company.where(status: Company::S_ACTIVE).order(created_at: :desc).page(params[:page]).per(30)
      @student_interests = StudentInterest.all
      @keyword = ''

      if params.has_key?(:keyword) && params[:keyword].present?
        @keyword = params[:keyword]
        @companies = @companies.where("(name_reveal = 1 and name like '%#{@keyword}%') or (business_summary = 1 and business_summary like '%#{@keyword}%')")
      end

      if params.has_key?(:business)
        @companies = @companies.where(business_type_id: params[:business])
      end

      @q = {}
      params.each do |k, v|
        if k != 'action' && k != 'controller' && v.present?
          if v.kind_of?(Array)
            @q[k] = []
            v.each {|t| @q[k] << t }
          else
            @q[k] = v
          end
        end
      end
    end
  end

  def show
    @company = Company.find(params[:id])

    if @company.status == Company::S_ACTIVE && @company.project.present?
      if user_signed_in? && current_user.student.present?
        @irs = Company::Ir.includes(:company_ir_students)
                   .where(company_id: @company.id, company_ir_students: { student_id: current_user.student.id })
                   .order(started_at: :desc)
                   .limit(5)
      else
        @irs = []
      end
    else
      render_404
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :user_id, :name, :name_kana, :president_first_name, :president_first_name_kana, :president_last_name,
      :president_last_name_kana, :president_birth_on, :zip_code, :prefecture_id, :city, :address1, :address2, :phone,
      :is_issuing, :is_accounting, :is_audit, :has_board, :market_cap, :issued_stock, :stage, :birth_on, :accounting_started_on,
      :settlement_month, :settlement_day, :image, :image_cache
    )
  end
end
