Feature: Chat Functionality
  As a logged-in user
  I want to send and receive chat messages in the game
  So that I can communicate with other players

  Background:
    Given I am a registered user with email "player@example.com" and password "PlayerPass123!"
    And I am logged in
    And I am on the game view for server "1"

  Scenario: Send a chat message successfully
    When I enter "Hello, world!" in the "chat-text" field
    And I press "Send"
    Then I should see "player@example.com" with the message "Hello, world!" in the chat

  Scenario: Receive a chat message from another user
    Given another user with email "friend@example.com" is registered and logged in to server "1"
    And "friend@example.com" sends the message "Hi there!"
    Then I should see "friend@example.com" with the message "Hi there!" in the chat

  Scenario: Attempt to send an empty chat message
    When I enter "" in the "chat-text" field
    And I press "Send"
    Then I should see "Message body can't be blank" on the page
