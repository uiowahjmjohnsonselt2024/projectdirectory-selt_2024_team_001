Feature: User Registration
  As a visitor
  I want to sign up for a new account
  So that I can access the game's features

  Background:
    Given I am on the login page

  Scenario: Successful registration with valid details
    When I press "Sign Up"
    And I fill in "Email" with "new_user@example.com"
    And I fill in "Password" with "SecurePass123!"
    And I fill in "Password Confirmation" with "SecurePass123!"
    And I press "Sign Up"
    Then I should see "Welcome to Shards of the Grid!" on the page
    And I should be logged in

  Scenario: Unsuccessful registration with invalid email
    When I press "Sign Up"
    And I fill in "Email" with "invalid_email"
    And I fill in "Password" with "SecurePass123!"
    And I fill in "Password Confirmation" with "SecurePass123!"
    And I press "Sign Up"
    Then I should see "Email is invalid" on the page

  Scenario: Unsuccessful registration with mismatched passwords
    When I press "Sign Up"
    And I fill in "Email" with "new_user@example.com"
    And I fill in "Password" with "SecurePass123!"
    And I fill in "Password Confirmation" with "DifferentPass!"
    And I press "Sign Up"
    Then I should see "Password confirmation doesn't match Password" on the page
