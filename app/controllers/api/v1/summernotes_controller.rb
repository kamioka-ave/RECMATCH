class Api::V1::SummernotesController < Api::V1::ApiController
  def create
    @summernote = Summernote.new(summernote_params)

    if admin_signed_in?
      @summernote.admin_id = current_admin.id
    end

    if @summernote.save
      render json: { url: @summernote.image.url }, status: 200
    else
      render nothing: true, status: 500
    end
  end

  private

  def summernote_params
    params.require(:summernote).permit(:image)
  end
end