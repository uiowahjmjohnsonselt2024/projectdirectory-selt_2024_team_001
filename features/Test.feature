Feature: Test.feature

Feature file for grouped scenarios related to Test.

  Scenario: Scenario based on Issue #2 - Login Screen For New User
    Given a new user on the login page
    When the user enters valid credentials
    Then the user should see a welcome message