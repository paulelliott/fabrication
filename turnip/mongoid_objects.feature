Feature: Mongoid Objects

  Scenario: for some generic objects
    Given 5 authors
    Then I should see 5 authors in the database

  Scenario: a single detailed object
    Given the following author:
      | name | George Orwell |
    Then I should see 1 author in the database
    And I should see the following author in the database:
      | name | George Orwell |

  Scenario: a single detailed object with a multi-word name
    Given the following "publishing house":
      | name | Random House |
    Then I should see 1 "publishing house" in the database
    And I should see the following "publishing house" in the database:
      | name | Random House |

  Scenario: multiple detailed objects
    Given the following authors:
      | name             |
      | Dr. Seuss        |
      | Shel Silverstein |
    Then I should see 2 authors in the database
    And I should see the following author in the database:
      | name | Dr. Seuss |
    And I should see the following author in the database:
      | name | Shel Silverstein |

  Scenario: a parented single detailed object
    Given 1 author
    And that author has the following book:
      | title | 1984 |
    Then I should see 1 author in the database
    And that book should be persisted
    And that book should have "1984" for a "title"
    And that book should reference that author

  Scenario: a parented object with a multi-word name
    Given 1 "publishing house"
    And that "publishing house" has the following "book promoter":
      | name | Vinnie |
    Then I should see 1 "publishing house" in the database
    And that "book promoter" should be persisted
    And that "book promoter" should have "Vinnie" for a "name"
    And that "book promoter" should reference that "publishing house"

  Scenario: a multi-word child belongs to a multi-word parent
    Given 1 "publishing house"
    And 1 "professional affiliation"
    And that "publishing house" belongs to that "professional affiliation"
    Then I should see 1 "publishing house" in the database
    And I should see 1 "professional affiliation" in the database
    And that "publishing house" should reference that "professional affiliation"

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
