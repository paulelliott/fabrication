Feature: Multiple Detailed Objects

  Scenario Outline: multiple detailed objects
    Given the following <fabricator name>s:
      | string field |
      | content1     |
      | content2     |
    Then I should see 2 <fabricator name>s in the database
    And I should see the following <fabricator name> in the database:
      | string_field | content1 |
    And I should see the following <fabricator name> in the database:
      | string_field | content2 |

  Scenarios:
      | fabricator name            |
      | parent active record model |
      | parent mongoid document    |
      | parent sequel model        |
