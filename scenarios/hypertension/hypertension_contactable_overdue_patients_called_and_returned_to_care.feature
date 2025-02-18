Feature: Contactable patients called and returned to care
  ___
  As a tester
  Given Some contactable overdue HTN TEIs return to care after being called
  When  I export the analytics
  Then I should see data in the "HTN - Contactable overdue patients called and returned to care" program indicator as expected
  ___

  Scenario: Overdue contactable patients called returned to care
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo_Plus_10_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 1 |
      | 6_MonthsAgo  | 0 |

  Scenario: Overdue non-contactable patients called returned to care
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo_Plus_10_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |

  Scenario: Overdue contactable patients called did not return to care
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |

  Scenario: Overdue contactable patients returned to care without being called
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo_Plus_10_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 3_MonthsAgo  | 0 |
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 0 |

  Scenario: Overdue contactable patients returned to care after 15 days
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "6_MonthsAgo_Plus_5_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |

  Scenario: Exclude contactable patients called and realized to be dead
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | REMOVE_FROM_OVERDUE |
      | HTN - Remove from overdue list because: | DIED                |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |


  Scenario: Exclude contactable patients called and realized as transfered to other facilities
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "5_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | REMOVE_FROM_OVERDUE             |
      | HTN - Remove from overdue list because: | MOVED_TO_ANOTHER_FACILITY |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |

  Scenario: Exclude contactable patients who had their last visit more than a year ago
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "13_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "13_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "12_MonthsAgo"
    And That TEI has a "Calling report" event on "12_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Hypertension & Diabetes visit" event on "12_MonthsAgo_Plus_5_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | thisMonth     | 0 |
      | 11_MonthsAgo  | 0 |
      | 12_MonthsAgo  | 1 |

  Scenario: Overdue contactable patients called anytime after they have become overdue, but returned on time, should count
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    Given I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Priyanka     |
      | GEN - Family name                     | Chopra       |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | District                              | KOLARA       |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo"
    And That TEI has a "Calling report" event on "4_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_MonthsAgo_Plus_10_Day" with following data
      | Systole  | 142 |
      | Diastole | 95  |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called and returned to care" with period type "Months" should be
      | 4_MonthsAgo  | 1 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |
