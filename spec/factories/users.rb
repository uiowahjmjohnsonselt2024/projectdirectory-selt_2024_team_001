# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    shards { 0 } # Default value from migration
    money { 0.0 } # Default value from migration

    trait :invalid_email do
      email { "invalid_email" }
    end
  end
end
