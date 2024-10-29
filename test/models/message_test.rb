require "test_helper"

class MessageTest < ActiveSupport::TestCase
  context 'message' do
    should 'create successfully' do
      message = create(:message)

      assert_equal 1, Message.count
    end

    should 'raise error without content' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:message, content: nil)
      end
    end
  end
end
