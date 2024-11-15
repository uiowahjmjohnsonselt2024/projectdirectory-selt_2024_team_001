Given("I am on the login page") do
  visit root_path
end

When("I enter {string} in the {string} field") do |value, field|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string} on the page") do |message|
  expect(page).to have_content(message)
end

Then("I should be on the sign-up page") do
  expect(page.current_path).to eq(signup_path)
end
