Feature: User Navigation and Login

  Scenario: Move to Sign Up page from Login page
    Given I am a new user
    When I select "SignUp"
    Then I should see the Sign Up page

  Scenario: Display the Login screen upon opening the app
    When I open the Heroku website app
    Then I should see the Login screen

  Scenario: Entering a username as an existing user
    Given I am an existing user on the Login screen
    When I select the username field
    Then I should be able to enter my username

  Scenario: Entering a password as an existing user
    Given I am an existing user on the Login screen
    When I select the password field
    Then I should be able to enter my password

  Scenario: Login with correct credentials as an existing user
    Given I am an existing user on the Login screen
    And I have entered my correct email and password
    When I select "Log In"
    Then I should be redirected to the Available Server screen
