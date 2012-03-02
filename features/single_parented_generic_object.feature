Feature: Single Parented Generic Object

  Scenario Outline:
    Given 1 <parent fabricator name>
    And that <parent fabricator name> has 1 <child fabricator name>
    Then I should see 1 <parent fabricator name> in the database
    And that <parent fabricator name> should have 1 <child fabricator name>

  Scenarios:
      | parent fabricator name     | child fabricator name       |
      | parent active record model | child active record model   |
      | parent mongoid document    | referenced mongoid document |
      | parent sequel model        | child sequel model          |
