class Api::V1::JnbTransfersController < Api::V1::ApiController
  def create
    data = JSON.parse(request.body.read)
    JnbTransfer.record!(URI.decode_www_form_component(data['jnb_transfer']['payload']))
    render json: {}, status: 200
  end
end