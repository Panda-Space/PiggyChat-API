require 'test_helper'

class ChannelControllerTest < ActionDispatch::IntegrationTest
  include JsonWebToken

  setup do
    @user = create(:user, username: 'pepo', email: 'pepo@g.com')
    @token = jwt_encode(user_id: @user.id)
  end

  context 'create' do
    should 'response :ok with right params' do
      post api_channels_path,
           params: { channel: { website: 'netflix.com', location: 'video/1234' } },
           headers: { Authorization: "Bearer #{@token}" }

      assert_response :ok
    end

    should 'response :unprocessable_entity with wrong params' do
      post api_channels_path,
           params: { channel: { location: 'video/1234' } },
           headers: { Authorization: "Bearer #{@token}" }

      assert_response :unprocessable_entity
    end

    should 'response :unprocessable_entity with website/location taken' do
      @channel = create(:channel)

      post api_channels_path,
           params: { channel: { website: @channel.website, location: @channel.location } },
           headers: { Authorization: "Bearer #{@token}" }           

      assert_response :unprocessable_entity
    end
  end

  context 'index' do
    should 'response :ok with website and location' do
      get api_channels_path,
           params: { website: 'netflix.com', location: 'video/1234' },
           headers: { Authorization: "Bearer #{@token}" }

      assert_response :ok
    end

    should 'response :unprocessable_entity with wrong params' do
      get api_channels_path,
           params: { location: 'video/1234' },
           headers: { Authorization: "Bearer #{@token}" }

      assert_response :unprocessable_entity
    end
  end

  context 'messages' do
    setup do
      @channel = create(:channel)

      create(:message, :with_user, channel: @channel)
      create(:message, :with_user, channel: @channel)
      create(:message, :with_user, channel: @channel)
    end

    should 'response :ok without pagination' do
      get messages_api_channel_path(id: @channel.id),
          headers: { Authorization: "Bearer #{@token}" }

      assert_response :ok
    end

    should 'response right size with right pagination' do
      get messages_api_channel_path(id: @channel.id),
          params: { page: 1, per_page: 2 },
          headers: { Authorization: "Bearer #{@token}" }

      data = JSON.parse(response.body)['data']

      assert_equal 2, data.size
    end
  end
end