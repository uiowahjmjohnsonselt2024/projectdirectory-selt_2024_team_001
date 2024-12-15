# features/step_definitions/navigation_steps.rb

Given('I am on the login page') do
  visit login_path
end

Given('I am on the welcome screen') do
  visit welcome_path
end

When('I navigate to the {string} section') do |section|
  click_link section
end

Then('I should see the welcome message for {string}') do |username|
  expect(page).to have_content("Welcome #{username}")
end

Then('I should see the game logo') do
  expect(page).to have_selector('img.game-logo')
end

Then('I should see a link to go back to login') do
  expect(page).to have_link('Back to Login', href: login_path)
end

When('I click the link to go back to login') do
  click_link 'Back to Login'
end

Then('I should be redirected to the login page') do
  expect(current_path).to eq(login_path)
  expect(page).to have_content('Login')
end
