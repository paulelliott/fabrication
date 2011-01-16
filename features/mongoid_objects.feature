Feature: Mongoid Objects

  Scenario: for some generic objects
    Given 5 authors
    Then there should be 5 authors

  Scenario: a single detailed object
    Given the following author:
      | name | George Orwell |
    Then that author should be persisted
    And that author should have "George Orwell" for a "name"

  Scenario: multiple detailed objects
    Given the following authors:
      | name             |
      | Dr. Seuss        |
      | Shel Silverstein |
    Then they should be persisted
    And the first should have "Dr. Seuss" for a "name"
    And the second should have "Shel Silverstein" for a "name"

  Scenario: a parented single detailed object
    Given 1 author
    And that author has the following book:
      | title | 1984 |
    Then that author should be persisted
    And that book should be persisted
    And that book should have "1984" for a "title"
    And that book should reference that author
