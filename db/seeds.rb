# Clear existing data to avoid duplicates
Achievement.destroy_all
User.destroy_all
Server.destroy_all
GridTile.destroy_all
StoreItem.destroy_all

# Create sample users with complex passwords
users = [
	{ email: 'john@gmail.com', password: 'Password123!', shards: 100, money: 2500.75 },
	{ email: 'rock@gmail.com', password: 'Rock@562', shards: 100, money: 2500.75 },
	{  email: 'smith@gmail.com', password: 'SecurePass456!', shards: 300, money: 1500.0 },
	{ email: 'alex@yahoo.com', password: 'MyPassword789!', shards: 50, money: 320.25 },
	{ email: 'legend47@gmail.com', password: '123SecurePass!', shards: 200, money: 500.0 },
	{  email: 'therealdonaldtrump@usa.com', password: 'MakeAmericaGreatAgain2024!', shards: 200, money: 1259.20 },
	{ email: 'admin@example.com', password: 'Admin1234!', shards: 2000000000, money: 1259000000.20 },
	{ email: 'test@gmail.com', password: 'Test#1', shards: 100, money: 5000.0 },
	{ email: 'seltgrader@nowhere.com', password: 'selt.is.#1.BEST.course', shards: 500, money: 5000.0 }
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

store_items = [
	# Ships
	{ title: "Falcon Scout", description: "A fast reconnaissance ship.", cost: 150, category: "Ship", modifier: "10%", currency: "Gold" },
	{ title: "Iron Bastion", description: "A heavily armored vessel.", cost: 250, category: "Ship", modifier: "15%", currency: "Gold" },
	{ title: "Nebula Runner", description: "Ideal for quick skirmishes.", cost: 200, category: "Ship", modifier: "12%", currency: "Gold" },
	{ title: "Star Sentry", description: "Balanced defense and offense.", cost: 300, category: "Ship", modifier: "18%", currency: "Gold" },
	{ title: "Cosmic Nomad", description: "Explorer ship for deep space travel.", cost: 500, category: "Ship", modifier: "20%", currency: "Shards" },
	{ title: "Phoenix Reborn", description: "Rebuilds itself after battles.", cost: 700, category: "Ship", modifier: "25%", currency: "Shards" },
	{ title: "Void Drifter", description: "Equipped for stealth missions.", cost: 450, category: "Ship", modifier: "22%", currency: "Shards" },
	{ title: "Galactic Titan", description: "The strongest combat ship.", cost: 1000, category: "Ship", modifier: "30%", currency: "Shards" },
	{ title: "Quantum Glide", description: "Incorporates warp speed tech.", cost: 900, category: "Ship", modifier: "28%", currency: "Shards" },
	{ title: "Solar Sprinter", description: "Solar-powered speed cruiser.", cost: 300, category: "Ship", modifier: "16%", currency: "Gold" },

	# Modules
	{ title: "Turbo Engine", description: "Boosts ship speed.", cost: 120, category: "Module", modifier: "10%", currency: "Gold" },
	{ title: "Nano Armor", description: "Reinforces hull integrity.", cost: 180, category: "Module", modifier: "15%", currency: "Gold" },
	{ title: "Ion Cannon", description: "Increases attack power.", cost: 250, category: "Module", modifier: "20%", currency: "Gold" },
	{ title: "Energy Stabilizer", description: "Improves energy efficiency.", cost: 220, category: "Module", modifier: "18%", currency: "Gold" },
	{ title: "Stealth Generator", description: "Grants temporary invisibility.", cost: 600, category: "Module", modifier: "25%", currency: "Shards" },
	{ title: "Shield Amplifier", description: "Doubles shield durability.", cost: 650, category: "Module", modifier: "28%", currency: "Shards" },
	{ title: "Hyper Drive", description: "Enables faster-than-light travel.", cost: 750, category: "Module", modifier: "30%", currency: "Shards" },
	{ title: "Holo Decoy System", description: "Creates holographic duplicates.", cost: 550, category: "Module", modifier: "22%", currency: "Shards" },
	{ title: "EMP Emitter", description: "Disables enemy systems temporarily.", cost: 500, category: "Module", modifier: "20%", currency: "Shards" },
	{ title: "Plasma Turrets", description: "Advanced plasma weaponry for defense.", cost: 300, category: "Module", modifier: "17%", currency: "Gold" },

	# Crew
	{ title: "Veteran Captain", description: "Expert at tactical decision-making.", cost: 200, category: "Crew", modifier: "12%", currency: "Gold" },
	{ title: "Chief Engineer", description: "Keeps systems running smoothly.", cost: 250, category: "Crew", modifier: "14%", currency: "Gold" },
	{ title: "Combat Pilot", description: "Excels at dogfighting maneuvers.", cost: 300, category: "Crew", modifier: "16%", currency: "Gold" },
	{ title: "Cybernetic Medic", description: "Enhances crew survivability.", cost: 400, category: "Crew", modifier: "18%", currency: "Gold" },
	{ title: "AI Navigator", description: "Precision navigation for complex routes.", cost: 600, category: "Crew", modifier: "20%", currency: "Shards" },
	{ title: "Elite Mercenary", description: "Boosts combat readiness.", cost: 650, category: "Crew", modifier: "22%", currency: "Shards" },
	{ title: "Master Scientist", description: "Enhances research capabilities.", cost: 700, category: "Crew", modifier: "25%", currency: "Shards" },
	{ title: "Infiltrator", description: "Specialized in sabotage missions.", cost: 800, category: "Crew", modifier: "30%", currency: "Shards" },
	{ title: "Communications Expert", description: "Secures intel and enhances diplomacy.", cost: 350, category: "Crew", modifier: "15%", currency: "Gold" },
	{ title: "Tactical Droid", description: "Provides combat assistance and analysis.", cost: 750, category: "Crew", modifier: "28%", currency: "Shards" },

	# Consumables
	{ title: "Health Pack", description: "Restores crew health.", cost: 50, category: "Consumable", modifier: "10%", currency: "Gold" },
	{ title: "Energy Cell", description: "Recharges ship energy.", cost: 75, category: "Consumable", modifier: "12%", currency: "Gold" },
	{ title: "Shield Booster", description: "Temporarily strengthens shields.", cost: 100, category: "Consumable", modifier: "15%", currency: "Gold" },
	{ title: "Combat Stimulant", description: "Increases combat efficiency.", cost: 120, category: "Consumable", modifier: "18%", currency: "Gold" },
	{ title: "Repair Kit", description: "Repairs minor hull damage.", cost: 150, category: "Consumable", modifier: "20%", currency: "Gold" },
	{ title: "Warp Fuel", description: "Enables instant travel.", cost: 400, category: "Consumable", modifier: "25%", currency: "Shards" },
	{ title: "AI Chip Upgrade", description: "Boosts system intelligence.", cost: 500, category: "Consumable", modifier: "30%", currency: "Shards" },
	{ title: "Nano Repair Swarm", description: "Autonomous hull repair.", cost: 350, category: "Consumable", modifier: "22%", currency: "Shards" },
	{ title: "Cloaking Serum", description: "Grants temporary invisibility.", cost: 600, category: "Consumable", modifier: "28%", currency: "Shards" },
	{ title: "Overdrive Injection", description: "Temporarily enhances all systems.", cost: 750, category: "Consumable", modifier: "35%", currency: "Shards" },

]
store_items.each do |item|
	StoreItem.create!(item)
end

puts "Servers seeded: #{Server.count}"
puts "Grid Tiles seeded: #{GridTile.count}"
puts "Store items seeded: #{StoreItem.count}"
