FactoryBot.define do
  factory :grid_tile do
    server
    sequence(:row) { |n| n % 6 + 1 } # Cycles through rows 1 to 6
    sequence(:column) { |n| n % 6 + 1 } # Cycles through columns 1 to 6
    weather { ["Clear", "Rainy", "Snowy"].sample }
    environment_type { ["Grassland", "Desert", "Forest"].sample }
    image_url { "https://example.com/image.png" }
  end
end
