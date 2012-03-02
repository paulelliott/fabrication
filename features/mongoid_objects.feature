Feature: Mongoid Objects

  Scenario: a parented single detailed object
    Given 1 author
    And that author has the following book:
      | title | 1984 |
    Then I should see 1 author in the database
    And that book should be persisted
    And that book should have "1984" for a "title"
    And that book should reference that author

  Scenario: multiple parented detailed objects
    Given 1 author
    And that author has the following books:
      | title       |
      | 1984        |
      | Animal Farm |
    Then I should see 1 author in the database
    And they should be persisted
    And they should reference that author
    And the first should have "1984" for a "title"
    And the second should have "Animal Farm" for a "title"
