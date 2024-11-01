FactoryBot.define do
  factory :message_interaction, class: 'MessageInteraction' do
    association :message
    association :user

    trait :with_user do
      user { User.first || association(:user) }
    end

    trait :with_message do
      message { Message.first || association(:message) }
    end
  end
end
