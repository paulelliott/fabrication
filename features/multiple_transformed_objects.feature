Feature: Multiple transformed objects

  Scenario Outline:
    Given the following <parent fabricator name>:
      | string field | Widgets Inc |
    And the following <child fabricator name>s:
      | number field | <parent field name> |
      | 10           | Widgets Inc         |
      | 20           | Widgets Inc         |
    Then they should reference that <parent fabricator name>

  Scenarios:
      | parent fabricator name     | child fabricator name       | parent field name          |
      | parent active record model | child active record model   | parent_active_record_model |
      | parent mongoid document    | referenced mongoid document | parent_mongoid_document    |
      | parent sequel model        | child sequel model          | parent_sequel_model        |
