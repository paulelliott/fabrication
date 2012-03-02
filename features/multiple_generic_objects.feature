Feature: Multiple Generic Objects

  Scenario Outline:
    Given 5 <fabricator name>s
    Then I should see 5 <fabricator name>s in the database

  Scenarios:
      | fabricator name            |
      | parent active record model |
      | parent mongoid document    |
      | parent sequel model        |
