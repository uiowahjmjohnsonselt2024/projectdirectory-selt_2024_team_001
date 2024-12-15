Feature: Save profile image functionality
  As a user
  I want to save my selected profile image
  So that it updates my profile avatar

  Background:
    Given I am logged in as a valid user
    And I am on the user profile page

  Scenario: Save button saves the selected profile image
    Given I see the dropdown menu is hidden
    When I click on the profile avatar
    Then I should see the dropdown menu
    When I select a profile image
    And I click the "Save" button
    Then the selected profile image should be saved
    And I should see a confirmation message "Profile picture updated successfully in session!"

  Scenario: Save button shows an alert when no image is selected
    Given I see the dropdown menu is hidden
    When I click on the profile avatar
    Then I should see the dropdown menu
    When I click the "Save" button without selecting an image
    Then I should see an alert "No image selected!"
    And the profile picture should remain unchanged
