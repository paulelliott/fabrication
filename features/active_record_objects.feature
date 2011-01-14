Feature: Active Record Objects

  Scenario: a single detailed object
    Given the following division:
      | name | Rasczak's Roughnecks |
    Then that division should be persisted
    And that division should have "Rasczak's Roughnecks" for a "name"
