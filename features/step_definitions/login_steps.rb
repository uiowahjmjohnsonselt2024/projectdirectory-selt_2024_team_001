# login_steps.rb

Given('a new user on the login page') do
  visit login_path # Navigates to the login page using Rails route helper
end

When('the user enters valid credentials') do
  fill_in 'email', with: 'new_user@example.com' # Replace with test email
  fill_in 'password', with: 'password123' # Replace with test password
  click_button 'Login'
end

Then('the user should see a welcome message') do
  expect(page).to have_content('Welcome') # Matches the welcome message on the page
end

Given('I am a new user') do
  visit login_path
end

When('I select "SignUp"') do
  find('button', text: 'Sign Up').click # Clicks the Sign Up button
end

Then('I should see the Sign Up page') do
  expect(page).to have_content('Sign Up') # Adjust if specific content exists
end

When('I open the Heroku website app') do
  visit root_path # Navigates to the root path
end

Then('I should see the Login screen') do
  expect(page).to have_selector('h2', text: 'Login') # Checks for the Login header
end

Given('I am an existing user on the Login screen') do
  visit login_path
end

When('I select the username field') do
  find_field('email').click # Simulates selecting the email field
end

Then('I should be able to enter my username') do
  fill_in 'email', with: 'existing_user@example.com' # Replace with test email
end

When('I select the password field') do
  find_field('password').click # Simulates selecting the password field
end

Then('I should be able to enter my password') do
  fill_in 'password', with: 'securepassword' # Replace with test password
end

Given('I have entered my correct email and password') do
  fill_in 'email', with: 'existing_user@example.com' # Use valid email
  fill_in 'password', with: 'password123' # Use valid password
end

When('I select "Log In"') do
  click_button 'Login' # Clicks the login button
end

Then('I should be redirected to the Available Server screen') do
  expect(page).to have_content('Welcome') # Matches welcome page content
end
