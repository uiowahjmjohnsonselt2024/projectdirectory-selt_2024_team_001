# spec/factories/user_servers.rb
FactoryBot.define do
  factory :user_server do
    association :user
    association :server
  end
end
