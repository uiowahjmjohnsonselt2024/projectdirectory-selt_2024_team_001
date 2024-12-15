# features/step_definitions/common_steps.rb

When('I press {string}') do |button_text|
  click_button button_text
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

Then('I should see {string} on the page') do |content|
  expect(page).to have_content(content)
end
