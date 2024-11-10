# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

# Create sample users
User.create!(
	username: 'john@gmail.com',
	password: 'password123',
	shard_amount: 100.5,
	money_usd: 2500.75
)

User.create!(
	username: 'smith@gmail.com',
	password: 'securepass456',
	shard_amount: 300.0,
	money_usd: 1500.0
)

User.create!(
	username: 'alex@yahoo.com',
	password: 'mypassword789',
	shard_amount: 50.25,
	money_usd: 320.25
)

User.create!(
	username: 'legend47@gmail.com',
	password: '123securepass',
	shard_amount: 200.75,
	money_usd: 500.0
)

User.create!(
	username: 'therealdonaldtrump@usa.com',
	password: 'MakeAmericanGreatAgain2024!',
	shard_amount: 200.75,
	money_usd: 1259.20
)
