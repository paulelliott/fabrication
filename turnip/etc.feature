Feature: Not ORM specific

  Scenario: fabricator doesn't exist
    When I try to fabricate "god"
    Then it should tell me that it isn't defined
