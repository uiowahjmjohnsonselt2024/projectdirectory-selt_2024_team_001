FactoryBot.define do
  factory :player do
    association :user
    association :server
    row { 0 }
    column { 0 }
  end
end
