@api
Feature: Create a project and check settings
  In order to start developing a drupal site
  As a project admin
  I need to create a new project

  Scenario: Create a new drupal 8 project

    Given I am logged in as a user with the "administrator" role
    And I am on the homepage
    When I click "Projects"
    And I click "Start a new Project"
    Then I should see "Step 1"
    Then I fill in "drpl8" for "Project Code Name"
    And I fill in "http://github.com/opendevshop/drupal_docroot.git" for "Git Repository URL"
    When I press "Next"

    # Step 2
    Then I should see "drpl8"
    And I should see "http://github.com/opendevshop/drupal_docroot.git"
    Then I should see "Please wait while we connect and analyze your repository."
    When I run drush "hosting-tasks --force --fork=0 --strict=0"
    # Then print last drush output
    And I reload the page

    Then I fill in "docroot" for "Document Root"
    When I press "Next"
    And I should see "DOCUMENT ROOT docroot"

    When I run drush "hosting-tasks --force --fork=0 --strict=0"
    And I reload the page
    And I reload the page

    Then I should see "Create as many new environments as you would like."
    When I fill in "dev" for "project[environments][NEW][name]"
    And I select "master" from "project[environments][NEW][git_ref]"

    And I press "Add environment"
    And I fill in "live" for "project[environments][NEW][name]"
    And I select "master" from "project[environments][NEW][git_ref]"
    And I press "Add environment"
    Then I press "Next"

    # Step 4
    And I should see "dev"
    And I should see "live"
    And I should see "master"

    When I run drush "hosting-tasks --force --fork=0 --strict=0"
    # Then print last drush output
    And I reload the page

    Then I should see "dev"
    And I should see "live"
    And I should see "master"

    And I should see "master"
    And I reload the page
#    When I click "Process Failed"
    Then I should see "8."
    Then I should not see "Platform verification failed"
    When I select "standard" from "install_profile"

#    Then I break

    And I press "Create Project & Environments"

    # FINISH!
    Then I should see "Your project has been created. Your sites are being installed."
    And I should see "Dashboard"
    And I should see "Settings"
    And I should see "Logs"
    And I should see "standard"
#    And I should see "http://github.com/opendevshop/drupal"
    And I should see the link "dev"
    And I should see the link "live"

#    Then I break
    And I should see the link "http://drpl8.dev.devshop.local.computer"
    And I should see the link "Aegir Site"

    When I run drush "hosting-tasks --force --fork=0 --strict=0"
    # Then print last drush output
    Then drush output should not contain "This task is already running, use --force"

    And I reload the page
    Then I should see the link "dev"
    Then I should see the link "live"
#    Given I go to "http://dev.drpl8.devshop.travis"
#    When I click "Visit Environment"

# @TODO: Fix our site installation.
#    Then I should see "No front page content has been created yet."

    When I click "Create New Environment"
    And I fill in "testenv" for "Environment Name"
    And I select "master" from "Branch or Tag"
    And I select the radio button "Drupal Profile"
    Then I select the radio button "Standard Install with commonly used features pre-configured."

    #@TODO: Check lots of settings

    When I fill in "testuser" for "Username"
    And I fill in "testpassword" for "Password"
    And I fill in "What's the password?" for "Message"

    Then I press "Create New Environment"
    Then I should see "Environment testenv created in project drpl8."

    When I run drush "hosting-tasks --force --fork=0 --strict=0"

    When I click "testenv" in the "main" region
    Then I should see "Environment Dashboard"
    And I should see "Environment Settings"

    And I click "Environment Settings"
    Then the field "Username" should have the value "testuser"
    Then the field "Password" should have the value "testpassword"
    Then the field "Message" should have the value "What's the password?"

    When I click "Project Settings"
    Then I select "testenv" from "Primary Environment"
    And I press "Save"

    Then I should see "DevShop Project drpl8 has been updated."
    And I should see an ".environment-link .fa-bolt" element

    # When I click "Visit Site"
    Given I am on "http://drpl8.testenv.devshop.local.computer"
# TODO: Figure out how to test this in travis!
#    Then the response status code should be 401

    Given I am on "http://testuser:testpassword@drpl8.testenv.devshop.local.computer"
    Then I should see "Welcome to drpl8.testenv"
