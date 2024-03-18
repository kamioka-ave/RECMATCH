class QuitsController < ApplicationController
  def show
    @quit = Quit.new
  end

  def confirm
    @quit = Quit.new(quit_params)

    unless @quit.valid?
      render :show
    end
  end

  def create
    @quit = Quit.new(quit_params)
    @quit.quit!(current_user)
    sign_out(current_user)
    redirect_to completion_quit_pages_path
  end

  private

  def quit_params
    params.require(:quit).permit(:note, quit_reason_ids: [])
  end
end
