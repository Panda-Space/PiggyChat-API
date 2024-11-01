require "test_helper"

class MessageInteractionTest < ActiveSupport::TestCase
  context 'message_interaction' do
    should 'create successfully' do
      message_interaction = create(:message_interaction, :with_message, :with_user)

      assert_equal 1, MessageInteraction.count
    end
  end
end
