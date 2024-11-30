Feature: User Login
  As a user
  I want to log in to my account
  So that I can access my personal information

  Background:
    Given I am on the login page

  Scenario: Successful login with valid credentials
    When I enter "legend47@gmail.com" in the "Email" field
    And I enter "123SecurePass!" in the "Password" field
    And I press "Login"
    Then I should see "Welcome back!" on the page

  Scenario: Unsuccessful login with invalid credentials
    When I enter "doesn't exist" in the "Email" field
    And I enter "badpassword" in the "Password" field
    And I press "Login"
    Then I should see "Invalid email or password" on the page

  Scenario: Redirect to sign-up page
    When I press "Sign Up"
    Then I should be on the sign-up page
