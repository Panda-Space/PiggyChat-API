require 'test_helper'

class ChannelControllerTest < ActionDispatch::IntegrationTest
  include JsonWebToken 

  context 'create' do
    setup do
      @user = create(:user)
      @token = jwt_encode(user_id: @user.id)
    end

    should 'response :ok with right params' do
      post api_channels_path,
           params: { channel: { website: 'netflix.com', location: 'video/1234' } },
           headers: { Authorization: "Bearear #{@token}" }

      assert_response :ok
    end

    should 'response :unprocessable_entity with wrong params' do
      post api_channels_path,
           params: { channel: { location: 'video/1234' } },
           headers: { Authorization: "Bearear #{@token}" }

      assert_response :unprocessable_entity
    end

    should 'response :unprocessable_entity with website/location taken' do
      @channel = create(:channel)

      post api_channels_path,
           params: { channel: { website: @channel.website, location: @channel.location } },
           headers: { Authorization: "Bearear #{@token}" }           

      assert_response :unprocessable_entity
    end
  end
end