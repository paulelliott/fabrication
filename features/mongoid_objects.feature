Feature: Mongoid Objects

  Scenario: for some generic objects
    Given 5 authors
    Then there should be 5 authors

  Scenario: a single detailed object
    Given the following author:
      | name | George Orwell |
    Then that author should be persisted
    And that author should have "George Orwell" for a "name"

  Scenario: a single detailed object with a multi-word name
    Given the following publishing house:
      | name | Random House |
    Then that publishing house should be persisted
    And that publishing house should have "Random House" for a "name"

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

  Scenario: a parented object with a multi-word name
    Given 1 publishing house
    And that publishing house has the following book promoter:
      | name | Vinnie |
    Then that publishing house should be persisted
    And that book promoter should be persisted
    And that book promoter should have "Vinnie" for a "name"
    And that book promoter should reference that publishing house

  Scenario: a multi-word child belongs to a multi-word parent
    Given 1 publishing house
    And 1 book promoter
    And that book promoter belongs to that publishing house
    Then that publishing house should be persisted
    And that book promoter should be persisted
    And that book promoter should reference that publishing house

  Scenario: multiple parented detailed objects
    Given 1 author
    And that author has the following books:
      | title       |
      | 1984        |
      | Animal Farm |
    Then that author should be persisted
    And they should be persisted
    And they should reference that author
    And the first should have "1984" for a "title"
    And the second should have "Animal Farm" for a "title"
