# features/step_definitions/authentication_steps.rb

Given('I am a registered user with email {string} and password {string}') do |email, password|
  FactoryBot.create(:user, email: email, password: password, password_confirmation: password)
end

Given('I am logged in') do
  visit login_path
  fill_in 'email', with: 'player@example.com'
  fill_in 'password', with: 'PlayerPass123!'
  click_button 'Login'
  expect(page).to have_content('Welcome back!')
end

Then('I should be logged in') do
  expect(page).to have_content('Welcome back!')
end

Then('I should be on the sign-up page') do
  expect(current_path).to eq(signup_path)
  expect(page).to have_content('Sign Up')
end
