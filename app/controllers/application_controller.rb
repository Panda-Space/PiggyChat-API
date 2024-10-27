class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include JsonWebToken

  before_action :authenticate_request

  private
    def authenticate_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header

      decoded = jwt_decode(header)

      if decoded == 'Token not found'
        render json: { error: 'No autorizado' }, status: :unauthorized
      else
          @current_user = User.find(decoded[:user_id])
      end
    end
end
