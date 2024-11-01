require "test_helper"

class MessageInteractionTest < ActiveSupport::TestCase
  context 'message_interaction' do
    should 'create successfully' do
      user = create(:user, username: 'rayin', email: 'rayin@g.com')
      message_interaction = create(:message_interaction, :with_message, user: user)

      assert_equal 1, MessageInteraction.where(user_id: user.id).size
    end
  end
end
