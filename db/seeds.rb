# Clear existing data to avoid duplicates
Achievement.destroy_all
User.destroy_all
Server.destroy_all
GridTile.destroy_all

# Create sample users with complex passwords
users = [
	{ email: 'john@gmail.com', password: 'Password123!', shards: 100, money: 2500.75 },
	{ email: 'rock@gmail.com', password: 'Rock@562', shards: 100, money: 2500.75 },
	{  email: 'smith@gmail.com', password: 'SecurePass456!', shards: 300, money: 1500.0 },
	{ email: 'alex@yahoo.com', password: 'MyPassword789!', shards: 50, money: 320.25 },
	{ email: 'legend47@gmail.com', password: '123SecurePass!', shards: 200, money: 500.0 },
	{  email: 'therealdonaldtrump@usa.com', password: 'MakeAmericaGreatAgain2024!', shards: 200, money: 1259.20 },
	{ email: 'admin@example.com', password: 'Admin1234!', shards: 2000000000, money: 1259000000.20 }
]

users.each do |user_data|
	User.create!(user_data)
end

puts "Users seeded: #{User.count}"

# Create sample servers
servers = [
	{ server_num: 1, status: "Open" },
	{ server_num: 2, status: "Open" },
	{ server_num: 3, status: "Open" }
]

servers.each do |server_data|
	Server.create!(server_data)
end

puts "Servers seeded: #{Server.count}"
puts "Grid Tiles seeded: #{GridTile.count}"
