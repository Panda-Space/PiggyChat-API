require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  context 'signup' do
    should 'response :ok with right params' do
      post signup_api_users_path,
           params: { user: { username: 'test', email: 'test@g.com', password: '123456789', avatar: 'green' } }

      assert_response :ok
    end

    should 'response :unprocessable_entity with wrong params' do
      post signup_api_users_path,
           params: { user: { email: 'test@g.com', password: '123456789', avatar: 'green' } }

      assert_response :unprocessable_entity
    end

    should 'response :unprocessable_entity with username/email taken' do
      create(:user)

      post signup_api_users_path,
           params: { user: { username: 'piggy', email: 'test@g.com', password: '123456789', avatar: 'green' } }

      assert_response :unprocessable_entity
    end
  end

  #TODO: Login
end