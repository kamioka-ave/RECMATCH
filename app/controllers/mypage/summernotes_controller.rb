class Mypage::SummernotesController < Mypage::MypageController
  before_action :authenticate_user!

  def create
    @summernote = Summernote.new(summernote_params)
    @summernote.user_id = current_user.id

    if @summernote.save
      render json: {url: @summernote.image.url}, status: 200
    else
      render nothing: true, status: 500
    end
  end

  private

  def summernote_params
    params.require(:summernote).permit(:image)
  end
end