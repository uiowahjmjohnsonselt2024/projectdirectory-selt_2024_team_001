# Clear existing data to avoid duplicates
User.destroy_all
Server.destroy_all
GridCell.destroy_all

# Create sample users with complex passwords
users = [
	{ username: 'john@gmail.com', email: 'john@gmail.com', password: 'Password123!', shards: 100, money: 2500.75 },
	{ username: 'smith@gmail.com', email: 'smith@gmail.com', password: 'SecurePass456!', shards: 300, money: 1500.0 },
	{ username: 'alex@yahoo.com', email: 'alex@yahoo.com', password: 'MyPassword789!', shards: 50, money: 320.25 },
	{ username: 'legend47@gmail.com', email: 'legend47@gmail.com', password: '123SecurePass!', shards: 200, money: 500.0 },
	{ username: 'therealdonaldtrump@usa.com', email: 'therealdonaldtrump@usa.com', password: 'MakeAmericaGreatAgain2024!', shards: 200, money: 1259.20 },
	{ username: 'admin@example.com', email: 'admin@example.com', password: 'Admin1234', shards: 2000000000, money: 1259000000.20 }
]

users.each do |user_data|
	User.create!(user_data)
end

puts "Users seeded: #{User.count}"

# Create sample servers
servers = [
	{ name: 'Alpha Server', max_players: 100, description: 'The first test server' },
	{ name: 'Beta Server', max_players: 200, description: 'Open for testing and debugging' },
	{ name: 'Gamma Server', max_players: 50, description: 'A smaller server for private games' }
]

servers.each do |server_data|
	Server.create!(server_data)
end

puts "Servers seeded: #{Server.count}"

# Create grid cells for each server
Server.find_each do |server|
	grid_size = 10 # 10x10 grid
	(0...grid_size).each do |row|
		(0...grid_size).each do |col|
			GridCell.create!(
				server: server,
				row: row,
				column: col,
				weather: ['clear', 'rainy', 'snowy'].sample, # Random weather
				environment_type: ['grassland', 'desert', 'forest'].sample, # Random environment type
				image_url: "https://example.com/image/#{row}_#{col}.png" # Placeholder image URL
			)
		end
	end
end

puts "Grid cells seeded: #{GridCell.count}"
