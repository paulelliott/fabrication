Feature: Fabricator doesn't exist

  Scenario:
    When I try to fabricate "god"
    Then it should tell me that it isn't defined
