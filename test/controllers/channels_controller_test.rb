require 'test_helper'

class ChannelControllerTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper
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
      @user = create(:user, username: 'topin', email: 'topin@g.com')
      @token = jwt_encode(user_id: @user.id)
      @channel = create(:channel)

      travel_to Time.zone.local(2024, 11, 2, 10, 0, 0) do
        @messages = [
          create(:message, :with_user, channel: @channel),
          create(:message, :with_user, channel: @channel),
        ]
      end

      travel_to Time.zone.local(2024, 11, 2, 12, 0, 0) do
        @messages << create(:message, :with_user, channel: @channel)
      end
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

    should 'response 3 unread messages without any viewed message' do
      get messages_api_channel_path(id: @channel.id),
          params: { unread: true },
          headers: { Authorization: "Bearer #{@token}" }

      data = JSON.parse(response.body)['data']

      assert_equal 3, data['count']
    end

    should 'response 1 unread messages with 2 viewed message' do
      travel_to Time.zone.local(2024, 11, 2, 11, 0, 0) do
        create(:message_interaction, viewed: true, user: @user, message: @messages[0])
        create(:message_interaction, viewed: true, user: @user, message: @messages[1])
      end

      travel_to Time.zone.local(2024, 11, 2, 13, 0, 0) do
        get messages_api_channel_path(id: @channel.id),
            params: { unread: true },
            headers: { Authorization: "Bearer #{@token}" }

        data = JSON.parse(response.body)['data']

        assert_equal 1, data['count']
      end
    end
  end

  context 'create_message' do
    setup do
      @channel = create(:channel)
      @room = "chat_#{@channel.id}"
    end

    should 'response :ok with right params' do
      post messages_api_channel_path(id: @channel.id),
          headers: { Authorization: "Bearer #{@token}" },
          params: { message: { content: 'Hola!' } }

      assert_response :ok
      assert_broadcast_on(ChatChannel.broadcasting_for(@room), text: "Testing!") do
        ChatChannel.broadcast_to @room, text: 'Testing!'
      end
    end

    should 'response :not_found with wrong channel' do
      post messages_api_channel_path(id: 44),
          headers: { Authorization: "Bearer #{@token}" }

      assert_response :not_found
    end

    should 'response :unprocessable_entity with wrong params' do
      post messages_api_channel_path(id: @channel.id),
          headers: { Authorization: "Bearer #{@token}" },
          params: { message: { content: '' } }

      assert_response :unprocessable_entity
    end
  end
end