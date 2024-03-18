class Admin::Projects::OrderRecordsController < Admin::AdminController
  before_action :set_project

  def new
    @order_record = OrderRecord.new(
      type: params[:type],
      term: OrderRecord::TM_DAILY
    )
  end

  def create
    @order_record = OrderRecord.new(order_record_params)
    @orders = Order.includes(:product, :project, :student).where(project_id: @project.id).order(:created_at)

    if @order_record.term == OrderRecord::TM_DAILY
      if @order_record.basis_end_on >= @project.start_at.to_date
        @orders = @orders.where(type: ['NormalOrder', 'CancelOrder'], created_at: (@order_record.basis_start_on)..(@order_record.basis_end_on.tomorrow - 1.second))
      else
        render_404
        return
      end
    elsif @order_record.term == OrderRecord::TM_EXECUTION
      @orders = @orders.where(type: ['NormalOrder', 'CancelOrder'])
    elsif @order_record.term == OrderRecord::TM_DELIVERY
      @orders = @orders.where(type: ['NormalOrder', 'CancelOrder', 'LostOrder'])
    elsif @order_record.term == OrderRecord::TM_LOST
      @orders = @orders.where(type: ['NormalOrder', 'CancelOrder', 'LostOrder'])
      @normal_orders = NormalOrder.where(project_id: @project.id).order(:created_at)
    end

    render(@order_record.render_params.merge(pdf: 'order_record'))
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def order_record_params
    params.require(:order_record).permit(:type, :term, :basis_start_on, :basis_end_on)
  end
end
