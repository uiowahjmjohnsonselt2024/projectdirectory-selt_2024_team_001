# features/step_definitions/player_movement_steps.rb

Given('I am on the game view for server {string}') do |server_id|
  server = FactoryBot.find_or_create(:server, id: server_id) do |s|
    s.name = "Server #{server_id}"
    s.initialize_grid unless s.grid_tiles.any?
  end
  visit game_view_server_path(server)
end

Given('my player is at row {string} and column {string}') do |row, column|
  user = User.find_by(email: 'player@example.com')
  server = Server.find(1)
  player = FactoryBot.find_or_create(:player, user: user, server: server)
  player.update!(row: row.to_i, column: column.to_i)
end

Given('I have {int} shards') do |shards|
  user = User.find_by(email: 'player@example.com')
  user.update!(gold: shards)
end

When('I select the grid cell at row {string} and column {string}') do |row, column|
  find(".grid-cell[data-row='#{row}'][data-column='#{column}']").click
end

When('I click {string}') do |button_text|
  click_button button_text
end

Then('my player should be at row {string} and column {string}') do |row, column|
  expect(page).to have_selector(".grid-cell.player-current[data-row='#{row}'][data-column='#{column}']")
end

Then('my shards should remain {string}') do |shards|
  user = User.find_by(email: 'player@example.com')
  expect(user.gold).to eq(shards.to_i)
end

Then('my shards should be {string}') do |shards|
  user = User.find_by(email: 'player@example.com')
  expect(user.gold).to eq(shards.to_i)
end

Then('my player should remain at row {string} and column {string}') do |row, column|
  expect(page).to have_selector(".grid-cell.player-current[data-row='#{row}'][data-column='#{column}']")
end
