FactoryBot.define do
  factory :message, class: 'Message' do
    association :channel
    association :user
    content { 'Hola mundo' }

    trait :with_user do
      user { User.first || association(:user) }
    end

    trait :with_channel do
      channel { Channel.first || association(:channel) }
    end
  end
end
