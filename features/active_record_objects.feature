Feature: Active Record Objects

  Scenario: for some generic objects
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

  Scenario: a parented single detailed object
    Given 1 company
    And that company has the following division:
      | name | Everyone |
    Then that company should be persisted
    And that division should be persisted
    And that division should have "Everyone" for a "name"
    And that division should reference that company
