Feature: Multiple Parented Detailed Objects

  Scenario Outline:
    Given 1 <parent fabricator name>
    And that <parent fabricator name> has the following <child fabricator name>s:
      | number field |
      | 20           |
      | 30           |
    Then I should see 1 <parent fabricator name> in the database
    And they should be persisted
    And they should reference that <parent fabricator name>
    And the first should have "20" for a "number field"
    And the second should have "30" for a "number field"

  Scenarios:
      | parent fabricator name     | child fabricator name       |
      | parent active record model | child active record model   |
      | parent mongoid document    | referenced mongoid document |
      | parent sequel model        | child sequel model          |
