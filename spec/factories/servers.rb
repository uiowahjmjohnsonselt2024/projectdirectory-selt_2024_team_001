FactoryBot.define do
  factory :server do
    sequence(:server_num) { |n| n }
    status { "Open" }

    after(:create) do |server, evaluator|
      next if Rails.env.test? || server.grid_tiles.any? # Skip if grid_tiles already exist

      grid_size = 6
      existing_tiles = server.grid_tiles.pluck(:row, :column).to_set

      (1..grid_size).each do |row|
        (1..grid_size).each do |col|
          unless existing_tiles.include?([row, col])
            create(:grid_tile, server: server, row: row, column: col)
          end
        end
      end
    end
  end
end
