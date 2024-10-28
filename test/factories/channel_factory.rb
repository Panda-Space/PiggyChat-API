FactoryBot.define do
  factory :channel, class: 'Channel' do
    website { 'netflix.com' }
    location { 'video/1234' }
  end
end