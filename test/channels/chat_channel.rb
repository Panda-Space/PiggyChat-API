require "test_helper"

class ChatChannelTest < ActionCable::Channel::TestCase
  test "subscribes and stream for room" do
    subscribe room: "15"

    assert subscription.confirmed?
    assert_has_stream "chat_15"
  end
end
