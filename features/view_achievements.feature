Feature: Viewing Achievements
  As a logged-in user
  I want to view my unlocked achievements
  So that I can track my progress in the game

  Background:
    Given I am a registered user with email "player@example.com" and password "PlayerPass123!"
    And I am logged in
    And I have unlocked the achievement "First Login"

  Scenario: View unlocked achievements
    When I navigate to the "Achievements" section
    Then I should see "First Login" on the page
    And I should see the achievement description "Logged in for the first time"

  Scenario: View achievements when none are unlocked
    Given I have not unlocked any achievements
    When I navigate to the "Achievements" section
    Then I should see "No achievements unlocked yet." on the page
