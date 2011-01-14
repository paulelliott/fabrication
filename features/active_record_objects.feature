Feature: Active Record Objects

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
