Feature: Contactable overdue patients called
  ___
  As a tester
  Given I call some contactable patients
  When  I export the analytics
  Then I should should see correct "HTN - Contactable overdue patients called" data
  ___

  Scenario: Contactable called overdue patients should be counted
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    And I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Rose         |
      | GEN - Family name                     | Mary         |
      | GEN - Sex                             | FEMALE       |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event scheduled for "6_MonthsAgo_Minus_1_Day"
    And That TEI has a "Calling report" event on "6_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | REMIND_TO_CALL_LATER |
    And That TEI has a "Calling report" event on "3_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called" with period type "Months" should be
      | 3_MonthsAgo | 1 |
      | 4_MonthsAgo | 0 |
      | 5_MonthsAgo | 0 |
      | 6_MonthsAgo | 1 |
      | 7_MonthsAgo | 0 |

  Scenario: Assume calls only happen to overdue patients, and count all patients called
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    And I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Frances      |
      | GEN - Family name                     | Bourgois     |
      | GEN - Sex                             | FEMALE       |
      | HTN - Does patient have hypertension? | YES          |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | Rose Gardens |
      | Patient Phone Number                  | 345672781624 |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Calling report" event on "6_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And That TEI has a "Calling report" event on "3_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called" with period type "Months" should be
      | 3_MonthsAgo | 1 |
      | 4_MonthsAgo | 0 |
      | 5_MonthsAgo | 0 |
      | 6_MonthsAgo | 1 |
      | 7_MonthsAgo | 0 |

  Scenario: Only managed patients should be counted (Hypertensive, alive, and in-facility)
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"

    # Create the patients
    And I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Nonne        |
      | GEN - Family name                     | Hypertensive |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | NO           |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | By the beach |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 119 |
      | Diastole | 69  |
    And That TEI has a "Calling report" event on "6_MonthsAgo_Plus_1_Day" with following data
      | Result of call                          | AGREE_TO_VISIT |
    And I create a new TEI on "5_MonthsAgo" for this Facility with the following attributes
      | GEN - Given name                      | Swimming with|
      | GEN - Family name                     | The Fishes   |
      | GEN - Sex                             | MALE         |
      | HTN - Does patient have hypertension? | NO           |
      | HTN - Does patient have diabetes?     | YES          |
      | GEN - Date of birth                   | 32           |
      | Address (current)                     | By the beach |
      | HTN - Consent to record data          | true         |
      | HTN - NCD Patient Status              | ACTIVE       |
    And That TEI has a "Calling report" event on "4_MonthsAgo" with following data
      | Result of call                          | AGREE_TO_VISIT |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Contactable overdue patients called" with period type "Months" should be
      | 3_MonthsAgo | 0 |
      | 4_MonthsAgo | 0 |
      | 5_MonthsAgo | 0 |
      | 6_MonthsAgo | 0 |
      | 7_MonthsAgo | 0 |
