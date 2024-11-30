Feature: Start Menu
  As a user
  I want to navigate from the welcome screen to the start menu or back to login
  So that I can begin my journey or return to the login page

  Background:
    Given I am on the welcome screen

  Scenario: Display welcome message with username
    Then I should see the welcome message for "legend47"
    And I should see the game logo

  Scenario: Start the journey
    When I press "Start Your Journey"
    Then I should be redirected to the start menu

  Scenario: Navigate back to login
    Then I should see a link to go back to login
    When I click the link to go back to login
    Then I should be redirected to the login page
