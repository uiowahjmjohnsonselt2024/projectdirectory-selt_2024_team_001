FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email } # Ensure unique emails
    password { "Password123!" }
    password_confirmation { "Password123!" }
    shards { 0 } # Default value from migration
    money { 0.0 } # Default value from migration

    trait :invalid_email do
      email { "invalid_email" } # Invalid email format
    end

    trait :with_money do
      money { Faker::Number.decimal(l_digits: 3, r_digits: 2) } # Random money value
    end

    trait :with_shards do
      shards { Faker::Number.between(from: 1, to: 100) } # Random shards value
    end
  end
end
