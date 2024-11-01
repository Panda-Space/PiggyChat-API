module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JsonWebToken

    identified_by :current_user

    def connect
      self.current_user = find_verified_user

      reject_unauthorized_connection unless current_user
    end

    private
      def find_verified_user
        auth_token = request.params[:auth_token]

        return if auth_token.nil?

        begin
          payload = jwt_decode(auth_token)

          User.find(payload[:user_id])
        rescue JWT::DecodeError
          nil
        end
      end
  end
end
