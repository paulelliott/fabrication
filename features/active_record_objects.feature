Feature: Active Record Objects

  Scenario: some generic objects
    Given 5 divisions
    Then there should be 5 divisions

  Scenario: a single detailed object
    Given the following division:
      | name | Rasczak's Roughnecks |
    Then that division should be persisted
    And that division should have "Rasczak's Roughnecks" for a "name"

  Scenario: multiple detailed objects
    Given the following divisions:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then they should be persisted
    And the first should have "Red Squadron" for a "name"
    And the second should have "Yellow Squadron" for a "name"

  Scenario: a parented single generic object
    Given 1 company
    And that company has 1 division
    Then that company should be persisted
    And that division should be persisted
    And that division should reference that company

  Scenario: a parented single detailed object
    Given 1 company
    And that company has the following division:
      | name | Everyone |
    Then that company should be persisted
    And that division should be persisted
    And that division should have "Everyone" for a "name"
    And that division should reference that company

  Scenario: a parented single detailed object with inheritance
    Given 1 company
    And that company has the following squadron:
      | name | Everyone |
    Then that company should be persisted
    And that squadron should be persisted
    And that squadron should have "Everyone" for a "name"
    And that squadron should reference that company

  Scenario: a parented single detailed object whose parent has inheritance
    Given 1 startup
    And that startup has the following division:
      | name | Everyone |
    Then that startup should be persisted
    And that division should be persisted
    And that division should have "Everyone" for a "name"
    And that division should reference that startup

  Scenario: multiple parented detailed objects
    Given 1 company
    And that company has the following divisions:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then that company should be persisted
    And they should be persisted
    And the first should have "Red Squadron" for a "name"
    And the second should have "Yellow Squadron" for a "name"
    And they should reference that company

  Scenario: multiple parented detailed objects with inheritance
    Given 1 company
    And that company has the following squadrons:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then that company should be persisted
    And they should be persisted
    And the first should have "Red Squadron" for a "name"
    And the second should have "Yellow Squadron" for a "name"
    And they should reference that company

    Scenario: multiple parented detailed objects whose parent has inheritance
    Given 1 startup
    And that startup has the following divisions:
      | name            |
      | Red Squadron    |
      | Yellow Squadron |
    Then that startup should be persisted
    And they should be persisted
    And the first should have "Red Squadron" for a "name"
    And the second should have "Yellow Squadron" for a "name"
    And they should reference that startup

  Scenario: a generic parent from the child
    Given 1 division
    And that division has 1 company
    Then that company should be persisted
    And that division should be persisted
    And that division should reference that company

  Scenario: a detailed parent from the child
    Given 1 division
    And that division has the following company:
      | name | Hashrocket |
    Then that company should be persisted
    And that division should be persisted
    And that company should have "Hashrocket" for a "name"
    And that division should reference that company

  Scenario: a parent with inheritance from the child
    Given 1 division
    And that division has the following startup:
      | name | Hashrocket |
    Then that startup should be persisted
    And that division should be persisted
    And that startup should have "Hashrocket" for a "name"
    And that division should reference that startup

  Scenario: a child belongs to a parent
    Given 1 company
    And 1 division
    And that division belongs to that company
    Then that company should be persisted
    And that division should be persisted
    And that division should reference that company

  Scenario: children belong to a parent
    Given 1 company
    And 2 divisions
    And those divisions belong to that company
    Then that company should be persisted
    And they should be persisted
    And they should reference that company

