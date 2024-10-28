require "test_helper"

class UserTest < ActiveSupport::TestCase
  context 'user' do
    should 'create successfully' do
      user = create(:user)

      assert_equal 1, User.count
    end

    should 'raise error without avatar' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:user, avatar: nil)
      end
    end

    should 'raise error without username' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:user, username: nil)
      end
    end

    should 'raise error without email' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:user, email: nil)
      end
    end

    should 'raise error without password' do
      assert_raises ActiveRecord::RecordInvalid do
        create(:user, password: nil)
      end
    end

    context 'with already user created' do
      setup do
        @user = create(:user)
      end

      should 'raise error with username taken' do
        assert_raises ActiveRecord::RecordInvalid do
          create(:user, username: 'piggy', email: 'piggy2@gmail.com')
        end
      end

      should 'raise error with email taken' do
        assert_raises ActiveRecord::RecordInvalid do
          create(:user, email: 'piggy@gmail.com', username: 'piggy2')
        end
      end
    end
  end
end
