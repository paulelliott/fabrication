Feature: Single Detailed Object

  Scenario Outline:
    Given the following <fabricator name>:
      | string field | some content |
    Then I should see 1 <fabricator name> in the database
    And I should see the following <fabricator name> in the database:
      | string_field | some content |

  Scenarios:
      | fabricator name            |
      | parent active record model |
      | parent mongoid document    |
      | parent sequel model        |
