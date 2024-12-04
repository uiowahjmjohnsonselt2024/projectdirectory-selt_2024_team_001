FactoryBot.define do
  factory :server do
    sequence(:server_num) { |n| n }
    status { "Open" }

    after(:create) do |server, evaluator|
      next if Rails.env.test? || server.grid_tiles.any? # Skip in test environment

      grid_size = 6
      (1..grid_size).each do |row|
        (1..grid_size).each do |col|
          create(:grid_tile, server: server, row: row, column: col)
        end
      end
    end
  end
end
