# login_steps.rb

# Background step
Given('I am on the login page') do
  visit login_path # Navigates to the login page using Rails route helper
end

# Steps for entering text in fields
When('I enter {string} in the {string} field') do |value, field|
  fill_in field, with: value # Dynamically fills in the specified field with the given value
end

# Step for clicking buttons
When('I press {string}') do |button_text|
  click_button button_text # Clicks the button with the specified text
end

# Step for verifying text on the page
Then('I should see {string} on the page') do |text|
  expect(page).to have_content(text) # Verifies that the specified text is visible on the page
end

# Step for checking page redirects
Then('I should be on the sign-up page') do
  expect(current_path).to eq(signup_path) # Verifies the user is on the sign-up page
end
