FactoryBot.define do
  factory :message_interaction, class: 'MessageInteraction' do
    association :user
    association :message

    trait :with_user do
      user { User.first || association(:user, email: 'top@g.com', username: 'topo') }
    end

    trait :with_message do
      message { Message.first || association(:message) }
    end
  end
end
