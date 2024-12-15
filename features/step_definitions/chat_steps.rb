# features/step_definitions/chat_steps.rb

Given('another user with email {string} is registered and logged in to server {string}') do |email, server_id|
  # Create and log in the other user
  other_user = FactoryBot.create(:user, email: email, password: 'FriendPass123!', password_confirmation: 'FriendPass123!')
  server = FactoryBot.create(:server, id: server_id) unless Server.exists?(id: server_id)
  FactoryBot.create(:user_server, user: other_user, server: server)

  # Use a separate Capybara session for the other user
  using_session(:other_user) do
    visit login_path
    fill_in 'email', with: email
    fill_in 'password', with: 'FriendPass123!'
    click_button 'Login'
    visit game_view_server_path(server)
  end
end

When('I enter {string} in the {string} field') do |message, field_id|
  fill_in field_id, with: message
end

When('I press {string}') do |button_text|
  click_button button_text
end

Then('I should see {string} with the message {string} in the chat') do |user_email, message|
  within('.chat-messages') do
    expect(page).to have_content(user_email)
    expect(page).to have_content(message)
  end
end

Given('I have unlocked the achievement {string}') do |achievement_name|
  user = User.find_by(email: 'player@example.com')
  FactoryBot.create(:achievement, name: achievement_name, description: "Logged in for the first time", user: user)
end
