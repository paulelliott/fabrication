Feature: Active Record Objects

  Scenario: a parented single detailed object with inheritance
    Given 1 company
    And that company has the following squadron:
      | name | Everyone |
    Then I should see 1 company in the database
    And I should see 1 squadron in the database
    And I should see the following division in the database:
      | name | Everyone |
    And that squadron should reference that company

  Scenario: a parented single detailed object whose parent has inheritance
    Given 1 startup
    And that startup has the following division:
      | name | Everyone |
    Then I should see 1 startup in the database
    And I should see 1 division in the database
    And I should see the following division in the database:
      | name | Everyone |
    And that division should reference that startup

  Scenario: multiple parented detailed objects with inheritance
    Given 1 company
    And that company has the following squadrons:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then I should see 1 company in the database
    And I should see 2 squadrons in the database
    And I should see the following division in the database:
      | name | Red Squadron |
    And I should see the following division in the database:
      | name | Yellow Squadron |
    And they should reference that company

    Scenario: multiple parented detailed objects whose parent has inheritance
    Given 1 startup
    And that startup has the following divisions:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then I should see 1 startup in the database
    And I should see 2 divisions in the database
    And I should see the following division in the database:
      | name | Red Squadron |
    And I should see the following division in the database:
      | name | Yellow Squadron |
    And they should reference that startup

  Scenario: a generic parent from the child
    Given 1 division
    And that division has 1 company
    Then I should see 1 division in the database
    And I should see 1 company in the database
    And that division should reference that company

  Scenario: a detailed parent from the child
    Given 1 division
    And that division has the following company:
      | name | Hashrocket |
    Then I should see 1 division in the database
    And I should see 1 company in the database
    And I should see the following company in the database:
      | name | Hashrocket |
    And that division should reference that company

  Scenario: a parent with inheritance from the child
    Given 1 division
    And that division has the following startup:
      | name | Hashrocket |
    Then I should see 1 startup in the database
    And I should see 1 division in the database
    And I should see the following company in the database:
      | name | Hashrocket |
    And that division should reference that startup

  Scenario: a child belongs to a parent
    Given 1 company
    And 1 division
    And that division belongs to that company
    Then I should see 1 division in the database
    And I should see 1 company in the database
    And that division should reference that company

  Scenario: an inherited child belongs to a parent
    Given 1 company
    And 1 squadron
    And that squadron belongs to that company
    Then I should see 1 squadron in the database
    And I should see 1 company in the database
    And that squadron should reference that company

  Scenario: a child belongs to an inherited parent
    Given 1 startup
    And 1 division
    And that division belongs to that startup
    Then I should see 1 division in the database
    And I should see 1 startup in the database
    And that division should reference that startup

  Scenario: children belong to a parent
    Given 1 company
    And 2 divisions
    And those divisions belong to that company
    Then I should see 1 company in the database
    And I should see 2 divisions in the database
    And they should reference that company
