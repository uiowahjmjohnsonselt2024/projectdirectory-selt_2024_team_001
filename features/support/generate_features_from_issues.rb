require 'octokit'
require 'cuke_modeler'
require 'fileutils'

# Set up Octokit client with your new token
client = Octokit::Client.new(access_token: 'YOUR_NEW_GITHUB_TOKEN')
repo = 'uiowahjmjohnsonselt2024/projectdirectory-selt_2024_team_001' # Replace with your GitHub repository (e.g., 'rutger0714/your-repo')

# Prompt for the issue number
if ARGV[0]
  issue_number = ARGV[0].to_i
else
  print "Enter the GitHub issue number: "
  issue_number = gets.chomp.to_i
end

# Prompt for or take a command-line argument for the step file name
if ARGV[1]
  step_file_name = ARGV[1]
else
  print "Enter the step definition file name (e.g., login_steps.rb): "
  step_file_name = gets.chomp
end

step_definition_path = "features/step_definitions/#{step_file_name}"

# Fetch the issue details
issue = client.issue(repo, issue_number)

# Generate the feature file name based on the issue title
feature_name = issue.title.gsub(' ', '_').downcase
feature_file_path = "features/#{feature_name}.feature"

# Create a new feature file using CukeModeler
feature = Model::Feature.new
feature.keyword = 'Feature'
feature.name = issue.title
feature.description = issue.body

# Add a sample scenario based on the issue description
scenario = Model::Scenario.new
scenario.keyword = 'Scenario'
scenario.name = 'User logs in with valid credentials'

# Add Given-When-Then steps to the scenario
scenario.steps = [
  Model::Step.new('Given', 'a new user on the login page'),
  Model::Step.new('When', 'the user enters valid credentials'),
  Model::Step.new('Then', 'the user should see a welcome message')
]

feature.tests << scenario

# Save the feature file
File.open(feature_file_path, 'w') { |file| file.write(feature.to_s) }

# Create a skeleton step definition file at the specified path
File.open(step_definition_path, 'w') do |file|
  file.puts "Given('a new user on the login page') do"
  file.puts "  # Add code to navigate to login page"
  file.puts "end\n\n"

  file.puts "When('the user enters valid credentials') do"
  file.puts "  # Add code to fill in login form with valid credentials"
  file.puts "end\n\n"

  file.puts "Then('the user should see a welcome message') do"
  file.puts "  # Add code to check for welcome message"
  file.puts "end\n"
end

puts "Feature file created at: #{feature_file_path}"
puts "Step definition file created at: #{step_definition_path}"

# Create a skeleton step definition file
File.open(step_definition_path, 'w') do |file|
  file.puts "Given('a new user on the login page') do"
  file.puts "  # Add code to navigate to login page"
  file.puts "end\n\n"

  file.puts "When('the user enters valid credentials') do"
  file.puts "  # Add code to fill in login form with valid credentials"
  file.puts "end\n\n"

  file.puts "Then('the user should see a welcome message') do"
  file.puts "  # Add code to check for welcome message"
  file.puts "end\n"
end

puts "Feature file created at: #{feature_file_path}"
puts "Step definition file created at: #{step_definition_path}"
