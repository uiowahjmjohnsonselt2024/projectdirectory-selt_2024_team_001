Given('I am logged in as a valid user') do
  @user = User.create(email: 'test@example.com', password: 'password')
  login_as(@user, scope: :user)
end


Given('I am on the user profile page') do
  visit user_profile_path(@user)
end

Given('I see the dropdown menu is hidden') do
  expect(page).not_to have_css('#dropdown-menu', visible: true)
end

When('I click on the profile avatar') do
  find('#current-profile-picture').click
end

Then('I should see the dropdown menu') do
  expect(page).to have_css('#dropdown-menu', visible: true)
end

When('I select a profile image') do
  find('#dropdown-menu .profile-option img', match: :first).click
end

When('I click the "Save" button') do
  find('.dropdown-save-btn .btn').click
end

When('I click the "Save" button without selecting an image') do
  find('.dropdown-save-btn .btn').click
end

Then('the selected profile image should be saved') do
  expect(page).to have_content('Profile picture updated successfully in session!')
end

Then('I should see a confirmation message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see an alert {string}') do |alert_message|
  page.accept_alert(alert_message)
end

Then('the profile picture should remain unchanged') do
  original_src = find('#current-profile-picture')[:src]
  expect(original_src).to eq('/profilePics/holder.png') # Replace with your default
end
