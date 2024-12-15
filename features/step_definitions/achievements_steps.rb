# features/step_definitions/achievements_steps.rb

Given('I have not unlocked any achievements') do
  user = User.find_by(email: 'player@example.com')
  user.achievements.destroy_all
end

When('I navigate to the {string} section') do |section|
  click_link section
end

Then('I should see {string} on the page') do |content|
  expect(page).to have_content(content)
end

Then('I should see the achievement description {string}') do |description|
  expect(page).to have_content(description)
end
