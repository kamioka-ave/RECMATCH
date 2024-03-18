class Admin::ConsultationsController < ApplicationController
  before_action :set_group_chat_category
  before_action :set_company, only: [:new, :create]
  before_action :set_consultation, only: [:destroy, :restore]

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = Consultation.find_or_initialize_by consultation_params
    if @consultation.save
      @consultations = @company.consultations.by_category(@group_chat_category.id).includes(:supporter)
    else
      render :new
    end
  end

  def restore
    redirect_to admin_group_chat_category_company_path(@group_chat_category, @consultation.company) if @consultation.restore
  end

  def destroy
    redirect_to admin_group_chat_category_company_path(@group_chat_category, @consultation.company) if @consultation.destroy
  end

  private

  def set_group_chat_category
    @group_chat_category = GroupChat::Category.find params[:group_chat_category_id]
  end

  def consultation_params
    params.require(:consultation).permit :group_chat_category_id, :supporter_id, :company_id
  end

  def set_consultation
    @consultation = Consultation.find params[:id]
  end

  def set_company
    @company = Company.find params[:company_id] || params[:consultation][:company_id]
  end
end
