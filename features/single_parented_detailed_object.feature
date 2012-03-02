Feature: Single Parented Detailed Object

  Scenario Outline:
    Given 1 <parent fabricator name>
    And that <parent fabricator name> has the following <child fabricator name>:
      | number field | 20 |
    Then I should see 1 <parent fabricator name> in the database
    And that <child fabricator name> should be persisted
    And that <child fabricator name> should have "20" for a "number field"
    And that <child fabricator name> should reference that <parent fabricator name>

  Scenarios:
      | parent fabricator name     | child fabricator name       |
      | parent active record model | child active record model   |
      | parent mongoid document    | referenced mongoid document |
      | parent sequel model        | child sequel model          |
