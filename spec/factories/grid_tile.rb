FactoryBot.define do
  factory :grid_cell do
    server
    row { rand(0..10) }
    column { rand(0..10) }
    weather { %w[clear rainy snowy].sample }
    environment_type { %w[forest desert grassland].sample }
  end
end
