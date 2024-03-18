module Errors
  extend ActiveSupport::Concern

  def render_404(e = nil)
    if request.xhr?
      render json: {error: '404 error'}, status: 404
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  def render_422(e = nil)
    if request.xhr?
      render json: {error: '422 error'}, status: 422
    else
      render file: "#{Rails.root}/public/422.html", layout: false, status: 422
    end
  end

  def render_500(e = nil)
    if request.xhr?
      render json: {error: '500 error'}, status: 500
    else
      render file: "#{Rails.root}/public/500.html", layout: false, status: 500
    end
  end
end