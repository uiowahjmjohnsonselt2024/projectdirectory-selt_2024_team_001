require 'octokit'
require 'cuke_modeler'
require 'fileutils'

# Read the GitHub token from a file named 'secret'
token = File.read('secret').strip
client = Octokit::Client.new(access_token: token)
repo = 'uiowahjmjohnsonselt2024/projectdirectory-selt_2024_team_001'  # Your repository

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

# Prompt for the target feature file
if ARGV[2]
  feature_file_name = ARGV[2]
else
  print "Enter the target feature file name (e.g., account_management.feature): "
  feature_file_name = gets.chomp
end

# Set paths
step_definition_path = "features/step_definitions/#{step_file_name}"
feature_file_path = "features/#{feature_file_name}"

# Fetch the issue details
issue = client.issue(repo, issue_number)

# Create a new scenario based on the issue description
scenario = CukeModeler::Scenario.new
scenario.keyword = 'Scenario'
scenario.name = "Scenario based on Issue ##{issue_number} - #{issue.title}"

# Initialize steps and set the keyword and text separately
steps = [
  CukeModeler::Step.new,
  CukeModeler::Step.new,
  CukeModeler::Step.new
]

# Set the keyword and text for each step
steps[0].keyword = 'Given'
steps[0].text = 'a new user on the login page'
steps[1].keyword = 'When'
steps[1].text = 'the user enters valid credentials'
steps[2].keyword = 'Then'
steps[2].text = 'the user should see a welcome message'

# Add steps to the scenario
scenario.steps = steps

# Check if the feature file exists; append if it does, otherwise create it
if File.exist?(feature_file_path)
  # Load the existing feature file and append the new scenario
  feature_model = CukeModeler::FeatureFile.new(feature_file_path).feature
  feature_model.tests << scenario

  # Save the modified feature file
  File.open(feature_file_path, 'w') { |file| file.write(feature_model.to_s) }
else
  # Create a new feature with the initial scenario if the file doesn't exist
  feature = CukeModeler::Feature.new
  feature.keyword = 'Feature'
  feature.name = feature_file_name.gsub('_', ' ').capitalize
  feature.description = "Feature file for grouped scenarios related to #{feature_file_name.gsub('.feature', '').gsub('_', ' ')}."

  feature.tests << scenario
  File.open(feature_file_path, 'w') { |file| file.write(feature.to_s) }
end

# Create or update the step definition file
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

puts "Feature file created or updated at: #{feature_file_path}"
puts "Step definition file created at: #{step_definition_path}"
