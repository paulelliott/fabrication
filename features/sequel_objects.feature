Feature: Sequel Objects

  Scenario: a class uses class table inheritance plugin
    Given 1 sequel_knight
    And 1 sequel_farmer
    And 1 sequel_knight
    Then I should see 3 sequel_farmers in the database
    And I should see 2 sequel_knight in the database
