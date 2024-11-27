# This file should contain all the record creation needed to seed the database with its default values.

# Clear existing data
User.destroy_all

# Create sample users with complex passwords
User.create!(
	username: 'john@gmail.com',
	email: 'john@gmail.com',
	password: 'Password123!',
	shards: 100,
	money: 2500.75
)

User.create!(
	username: 'smith@gmail.com',
	email: 'smith@gmail.com',
	password: 'SecurePass456!',
	shards: 300,
	money: 1500.0
)

User.create!(
	username: 'alex@yahoo.com',
	email: 'alex@yahoo.com',
	password: 'MyPassword789!',
	shards: 50,
	money: 320.25
)

User.create!(
	username: 'legend47@gmail.com',
	email: 'legend47@gmail.com',
	password: '123SecurePass!',
	shards: 200,
	money: 500.0
)

User.create!(
	username: 'therealdonaldtrump@usa.com',
	email: 'therealdonaldtrump@usa.com',
	password: 'MakeAmericaGreatAgain2024!',
	shards: 200,
	money: 1259.20
)
User.create!(
	username: 'admin@example.com',
	email: 'admin@example.com',
	password: 'Admin1234',
	shards: 2000000000,
	money: 1259000000.20
)