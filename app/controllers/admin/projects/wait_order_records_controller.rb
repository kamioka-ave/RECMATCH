class Admin::Projects::WaitOrderRecordsController < Admin::AdminController
  before_action :set_project

  def new
    @wait_order_record = WaitOrderRecord.new(
      type: params[:type],
      term: WaitOrderRecord::TM_DAILY
    )
  end

  def create
    @wait_order_record = WaitOrderRecord.new(wait_order_record_params)
    @wait_orders = Order.includes(:product, :project, :student)
                     .where(type: ['WaitOrder', 'CancelWaitOrder', 'AbortWaitOrder'], project_id: @project.id)
                     .order(:created_at)

    if @wait_order_record.term == WaitOrderRecord::TM_DAILY
      if @wait_order_record.basis_end_on >= @project.start_at.to_date
        @wait_orders = @wait_orders.where(created_at: (@wait_order_record.basis_start_on)..(@wait_order_record.basis_end_on.tomorrow - 1.second))
      else
        render_404
        return
      end
    end

    render(@wait_order_record.render_params.merge(pdf: 'wait_order_record'))
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def wait_order_record_params
    params.require(:wait_order_record).permit(:type, :term, :basis_start_on, :basis_end_on)
  end
end
