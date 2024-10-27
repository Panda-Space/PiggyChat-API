FactoryBot.define do
  factory :user, class: 'User' do
    email { 'piggy@gmail.com' }
    username { 'piggy' }
    password { '123456789' }
    avatar { 'green' }
  end
end