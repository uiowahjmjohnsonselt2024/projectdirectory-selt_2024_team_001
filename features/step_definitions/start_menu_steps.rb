# start_menu_steps.rb

Given('I am on the welcome screen') do
  visit welcome_path # Replace with the actual route to the welcome screen
end

Then('I should see the welcome message for {string}') do |username|
  expect(page).to have_content("Welcome \"#{username}\"!!") # Checks for the dynamic welcome message
end

Then('I should see the game logo') do
  expect(page).to have_selector('img.game-logo') # Verifies the presence of the game logo image
end

When('I press {string}') do |button_text|
  click_button button_text # Simulates clicking the button (e.g., "Start Your Journey")
end

Then('I should be redirected to the start menu') do
  expect(current_path).to eq(start_menu_path) # Verifies the user is redirected to the start menu
end

Then('I should see a link to go back to login') do
  expect(page).to have_link('Back to Login', href: login_path) # Verifies the presence of the "Back to Login" link
end

When('I click the link to go back to login') do
  click_link 'Back to Login' # Simulates clicking the "Back to Login" link
end

Then('I should be redirected to the login page') do
  expect(current_path).to eq(login_path) # Verifies the user is redirected to the login page
end

