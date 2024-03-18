class Admin::LandingsController < Admin::AdminController
  def index
    @q = Landing.ransack(params[:q])
    @landings = @q.result.order('created_at desc').page(params[:page]).per(100)
  end

  def destroy
    @landing = Landing.find(params[:id])
    @landing.destroy
    redirect_to admin_landings_path, notice: '事前申込みを削除しました'
  end

  def download
    csv = Landing.to_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data bom + csv.encode!(Encoding::UTF_8), type: 'text/csv'
  end
end
