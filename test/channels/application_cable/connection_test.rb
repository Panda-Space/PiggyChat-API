require "test_helper"

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    include JsonWebToken

    setup do
      @user = create(:user, username: 'pepo', email: 'pepo@g.com')
      @token = jwt_encode(user_id: @user.id)
    end

    should 'connects with right params' do
      connect params: { auth_token: @token }

      assert_equal connection.current_user, @user
    end

    should 'rejects connection with wrong params' do
      assert_reject_connection { connect }
    end
  end
end
