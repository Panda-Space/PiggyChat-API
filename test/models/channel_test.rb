require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  context 'channel' do
    should 'create successfully' do
      channel = create(:channel)

      assert_equal 1, Channel.count
    end

    should 'raise error without website' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:channel, website: nil)
      end
    end

    should 'raise error without location' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:channel, location: nil)
      end
    end

    context 'with already channel created' do
      setup do
        @channel = create(:channel)
      end

      should 'raise error with website taken' do
        assert_raises ActiveRecord::RecordInvalid do
          create(:channel, website: 'netflix.com', location: 'video/4321')
        end
      end

      should 'raise error with location taken' do
        assert_raises ActiveRecord::RecordInvalid do
          create(:channel, website: 'cuevana.com', location: 'video/1234')
        end
      end
    end
  end
end
