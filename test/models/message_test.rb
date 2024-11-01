require "test_helper"

class MessageTest < ActiveSupport::TestCase
  context 'message' do
    should 'create successfully and mark as viewed' do
      message = create(:message)

      assert_equal 1, Message.count
      assert_equal 1, message.message_interactions.where(viewed: true).size
    end

    should 'raise error without content' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:message, content: nil)
      end
    end
  end
end
