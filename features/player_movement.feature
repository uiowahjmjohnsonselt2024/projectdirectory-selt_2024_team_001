Feature: Player Movement
  As a logged-in user
  I want to move my player on the game grid
  So that I can explore the game world

  Background:
    Given I am a registered user with email "player@example.com" and password "PlayerPass123!"
    And I am logged in
    And I am on the game view for server "1"
    And my player is at row "0" and column "0"
    And I have 10 shards

  Scenario: Move player to an adjacent cell without cost
    When I select the grid cell at row "0" and column "1"
    And I click "Move Player"
    Then my player should be at row "0" and column "1"
    And my shards should remain "10"

  Scenario: Move player to a non-adjacent cell with cost
    When I select the grid cell at row "2" and column "2"
    And I click "Move Player"
    Then my player should be at row "2" and column "2"
    And my shards should be "8"

  Scenario: Attempt to move to a non-existent cell
    When I select the grid cell at row "10" and column "10"
    And I click "Move Player"
    Then I should see "Invalid target position. The tile does not exist." on the page
    And my player should remain at row "0" and column "0"

  Scenario: Attempt to move without enough shards
    Given I have 0 shards
    When I select the grid cell at row "1" and column "1"
    And I click "Move Player"
    Then I should see "Insufficient shards for movement." on the page
    And my player should remain at row "0" and column "0"
