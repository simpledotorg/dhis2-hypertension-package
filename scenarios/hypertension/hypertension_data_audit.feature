Feature: Hypertension Data Audit
  ____
  As a tester
  Given I have a few tracked entity instances with event history in the system
  When  I export the analytics and run the hypertension data aggregation
  Then  I should see all the hypertension program indicator data for each month as expected
  ____

  Scenario: Verify all the hypertension monthly program indicator
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"
    #
    # Patient 1 - Dead
    #

    And I create a new TEI on "7_MonthsAgo_BeginningOfMonth" for this Facility with the following attributes
      | Given name         | Joe          |
      | Family name        | Bloggs       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 145 |
      | Diastole | 92  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 136 |
      | Diastole | 84  |
    And That TEI was updated on "2_MonthsAgo" with the following attributes
      | NCD Patient Status | DIED |
    #
    # Patient 2 - Not a hypertension TEI
    #
    And I create a new TEI on "5_MonthsAgo" for this Facility with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | NO           |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | HBA1C |
      | HTN - Blood sugar reading       | 9     |
    #
    #  Patient 3 - Patient under care, TEI under care registered before the past 3 months and controlled
    #
    And I create a new TEI on "10_MonthsAgo" for this Facility with the following attributes
      | Given name         | Sue          |
      | Family name        | Perkins      |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "10_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "9_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 137 |
      | Diastole | 86  |
    #
    #  Patient 4 - Patient under care, TEI under care registered before the past 3 months and controlled
    #
    And I create a new TEI on "19_MonthsAgo" for this Facility with the following attributes
      | Given name         | Kiran        |
      | Family name        | Kishor       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "19_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event on "18_MonthsAgo" with following data
      | Systole  | 139 |
      | Diastole | 90  |
    And That TEI has a "Hypertension & Diabetes visit" event on "17_MonthsAgo" with following data
      | Systole  | 132 |
      | Diastole | 82  |
    And That TEI has a "Hypertension & Diabetes visit" event on "16_MonthsAgo" with following data
      | Systole  | 128 |
      | Diastole | 72  |
    And That TEI has a "Hypertension & Diabetes visit" event on "15_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 88  |
    #
    #  Patient 5 - Patient under care, TEI under care registered before the past 3 months and uncontrolled
    #
    And I create a new TEI on "8_MonthsAgo" for this Facility with the following attributes
      | Given name         | Lilly        |
      | Family name        | Martin       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "8_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 132 |
      | Diastole | 82  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 91  |
  #
  #  Patient 6 - Patient under care, TEI under care registered before the past 3 months and no visit in last 3 months
  #
    And I create a new TEI on "12_MonthsAgo" for this Facility with the following attributes
      | Given name         | Ajesh        |
      | Family name        | Choudhary    |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "12_MonthsAgo" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "11_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "10_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "9_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 91  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 148 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 136 |
      | Diastole | 82  |
  #
  #  Patient 7 - Patient under care, TEI under care registered before the past 3 months and controlled
  #
    And I create a new TEI on "4_MonthsAgo" for this Facility with the following attributes
      | Given name         | Bianca       |
      | Family name        | Santos       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_MonthsAgo" with following data
      | Systole  | 141 |
      | Diastole | 94  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
  #
  #  Patient 8 - Patient has not visited for more than 12 months
  #
    And I create a new TEI on "16_MonthsAgo" for this Facility with the following attributes
      | Given name         | Joanne       |
      | Family name        | Holme        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "16_MonthsAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
  #
  #  Patient 9 - Patient under care, TEI under care registered before the past 3 months and controlled
  #
    And I create a new TEI on "6_MonthsAgo" for this Facility with the following attributes
      | Given name         | Karlo        |
      | Family name        | Petersen     |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 145 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 91  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 128 |
      | Diastole | 76  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_MonthsAgo" with following data
      | Systole  | 125 |
      | Diastole | 77  |
  #
  #  Patient 10 - Patient under care, TEI under care registered before the past 3 months and controlled
  #
    And I create a new TEI on "8_MonthsAgo" for this Facility with the following attributes
      | Given name         | Adrien       |
      | Family name        | Palomo       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "8_MonthsAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
  #
  #  Patient 11 -  Patient under care, TEI under care registered before the past 3 months and no visit
  #
    And I create a new TEI on "9_MonthsAgo" for this Facility with the following attributes
      | Given name         | Iverna       |
      | Family name        | Terrazas     |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "9_MonthsAgo" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "8_MonthsAgo" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 137 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_MonthsAgo" with following data
      | Systole                         | 130      |
      | Diastole                        | 81       |
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 200      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_MonthsAgo_Plus_4_Days" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 100      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Cumulative dead patients" with period type "Months" should be
      | 12_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 10_MonthsAgo | 0 |
      | 9_MonthsAgo  | 0 |
      | 8_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 1 |
      | 6_MonthsAgo  | 1 |
      | 5_MonthsAgo  | 1 |
      | 4_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 1 |
      | 2_MonthsAgo  | 1 |
      | 1_MonthAgo   | 1 |
      | thisMonth    | 1 |
    Then The value of "PI":"HTN - Cumulative registrations" with period type "Months" should be
      | 12_MonthsAgo | 3 |
      | 11_MonthsAgo | 3 |
      | 10_MonthsAgo | 4 |
      | 9_MonthsAgo  | 5 |
      | 8_MonthsAgo  | 7 |
      | 7_MonthsAgo  | 7 |
      | 6_MonthsAgo  | 8 |
      | 5_MonthsAgo  | 8 |
      | 4_MonthsAgo  | 9 |
      | 3_MonthsAgo  | 9 |
      | 2_MonthsAgo  | 9 |
      | 1_MonthAgo   | 9 |
      | thisMonth    | 9 |
    Then The value of "PI":"HTN - Monthly registrations" with period type "Months" should be
      | 12_MonthsAgo | 1 |
      | 11_MonthsAgo | 0 |
      | 10_MonthsAgo | 1 |
      | 9_MonthsAgo  | 1 |
      | 8_MonthsAgo  | 2 |
      | 7_MonthsAgo  | 1 |
      | 6_MonthsAgo  | 1 |
      | 5_MonthsAgo  | 0 |
      | 4_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 0 |
      | 2_MonthsAgo  | 0 |
      | 1_MonthAgo   | 0 |
      | thisMonth    | 0 |
    Then The value of "PI":"HTN - Patients under care with controlled BP at latest visit in past 3 months and registered before the past 3 months" with period type "Months" should be
      | 12_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 10_MonthsAgo | 0 |
      | 9_MonthsAgo  | 0 |
      | 8_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 3 |
      | 5_MonthsAgo  | 4 |
      | 4_MonthsAgo  | 4 |
      | 3_MonthsAgo  | 5 |
      | 2_MonthsAgo  | 3 |
      | 1_MonthAgo   | 4 |
      | thisMonth    | 3 |

    Then The value of "PI":"HTN - Patients under care with no visit in past 3 months registered before the past 3 months" with period type "Months" should be
      | 12_MonthsAgo | 2 |
      | 11_MonthsAgo | 2 |
      | 10_MonthsAgo | 2 |
      | 9_MonthsAgo  | 2 |
      | 8_MonthsAgo  | 2 |
      | 7_MonthsAgo  | 2 |
      | 6_MonthsAgo  | 2 |
      | 5_MonthsAgo  | 2 |
      | 4_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 1 |
      | 2_MonthsAgo  | 2 |
      | 1_MonthAgo   | 2 |
      | thisMonth    | 3 |
    Then The value of "PI":"HTN - Patients under care with uncontrolled BP at latest visit in past 3 months registered before the past 3 months" with period type "Months" should be
      | 12_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 10_MonthsAgo | 0 |
      | 9_MonthsAgo  | 1 |
      | 8_MonthsAgo  | 1 |
      | 7_MonthsAgo  | 2 |
      | 6_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 1 |
      | 4_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 0 |
      | 2_MonthsAgo  | 1 |
      | 1_MonthAgo   | 1 |
      | thisMonth    | 1 |
    Then The value of "PI":"HTN - Patients with no visit in last 12 months" with period type "Months" should be
      | 12_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 10_MonthsAgo | 0 |
      | 9_MonthsAgo  | 0 |
      | 8_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |
      | 5_MonthsAgo  | 0 |
      | 4_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 2 |
      | 2_MonthsAgo  | 2 |
      | 1_MonthAgo   | 2 |
      | thisMonth    | 2 |

    Then The value of "PI":"HTN - Patients under care registered before the past 3 months." with period type "Months" should be
      | 12_MonthsAgo | 2 |
      | 11_MonthsAgo | 2 |
      | 10_MonthsAgo | 2 |
      | 9_MonthsAgo  | 3 |
      | 8_MonthsAgo  | 3 |
      | 7_MonthsAgo  | 4 |
      | 6_MonthsAgo  | 5 |
      | 5_MonthsAgo  | 7 |
      | 4_MonthsAgo  | 6 |
      | 3_MonthsAgo  | 6 |
      | 2_MonthsAgo  | 6 |
      | 1_MonthAgo   | 7 |
      | thisMonth    | 7 |
  Scenario: Verify all the hypertension quarterly program indicator
    Given I am signed in as a user with role "Superuser"
    And I have access to an organisation unit at level 5
    And I register that organisation unit for program "Hypertension & Diabetes"
    #
    # Patient 1 - Dead
    #

    And I create a new TEI on "3_QuartersAgo" for this Facility with the following attributes
      | Given name         | Joe          |
      | Family name        | Bloggs       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 145 |
      | Diastole | 92  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuarterAgo_Plus_2_Months" with following data
      | Systole  | 140 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 136 |
      | Diastole | 84  |
    And That TEI was updated on "thisQuarter" with the following attributes
      | NCD Patient Status | DIED |
    #
    # Patient 2 - Not a hypertension TEI
    #
    And I create a new TEI on "3_QuarterAgo" for this Facility with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | NO           |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuarterAgo" with following data
      | HTN - Type of diabetes measure? | HBA1C |
      | HTN - Blood sugar reading       | 9     |
    #
    #  Patient 3 - Patient under care, TEI under care registered before the past 3 months and controlled visit in following quarter
    #
    And I create a new TEI on "4_QuartersAgo" for this Facility with the following attributes
      | Given name         | Sue          |
      | Family name        | Perkins      |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_QuartersAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_2_Month" with following data
      | Systole  | 134 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 137 |
      | Diastole | 86  |
    #
    #  Patient 4 - Patient under care, TEI under care registered before the past 3 months and uncontrolled visit in following quarter
    #
    And I create a new TEI on "3_QuartersAgo" for this Facility with the following attributes
      | Given name         | Kiran        |
      | Family name        | Kishor       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 139 |
      | Diastole | 90  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_2_Month" with following data
      | Systole  | 132 |
      | Diastole | 82  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo" with following data
      | Systole  | 128 |
      | Diastole | 72  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 140 |
      | Diastole | 88  |
    #
    #  Patient 5 - Patient under care, TEI under care registered before the past 3 months and uncontrolled visit in following quarter
    #
    And I create a new TEI on "4_QuartersAgo_Plus_2_Months" for this Facility with the following attributes
      | Given name         | Lilly        |
      | Family name        | Martin       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_QuartersAgo_Plus_2_Months" with following data
      | Systole  | 142 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 132 |
      | Diastole | 82  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_1_Months" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_2_Months" with following data
      | Systole  | 143 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 138 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_2_Months" with following data
      | Systole  | 140 |
      | Diastole | 91  |
  #
  #  Patient 6 - Patient under care, TEI under care registered before the past 3 months and uncontrolled visit in following quarter
  #
    And I create a new TEI on "5_QuartersAgo" for this Facility with the following attributes
      | Given name         | Ajesh        |
      | Family name        | Choudhary    |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_QuartersAgo" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_QuartersAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "4_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 143 |
      | Diastole | 91  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 148 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 136 |
      | Diastole | 82  |
  #
  #  Patient 7 - Patient under care, TEI under care registered before the past 3 months and no visit in following quarter
  #
    And I create a new TEI on "3_QuartersAgo" for this Facility with the following attributes
      | Given name         | Bianca       |
      | Family name        | Santos       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 141 |
      | Diastole | 94  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuarterAgo_Plus_1_Month" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuarterAgo_Plus_2_Month" with following data
      | Systole  | 138 |
      | Diastole | 83  |
  #
  #  Patient 8 - Patient who has no visit in following quarter
  #
    And I create a new TEI on "2_QuartersAgo" for this Facility with the following attributes
      | Given name         | Joanne       |
      | Family name        | Holme        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
  #
  #  Patient 9 - Patient under care, TEI under care registered before the past 3 months and controlled visit in following quarter
  #
    And I create a new TEI on "2_QuartersAgo" for this Facility with the following attributes
      | Given name         | Karlo        |
      | Family name        | Petersen     |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_QuarterAgo" with following data
      | Systole  | 145 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 138 |
      | Diastole | 91  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_QuarterAgo_Plus_2_Month" with following data
      | Systole  | 128 |
      | Diastole | 76  |
    And That TEI has a "Hypertension & Diabetes visit" event on "thisQuarter" with following data
      | Systole  | 125 |
      | Diastole | 77  |
  #
  #  Patient 10 - Patient under care, TEI under care registered before the past 3 months and controlled visit in following quarter
  #
    And I create a new TEI on "3_QuartersAgo" for this Facility with the following attributes
      | Given name         | Adrien       |
      | Family name        | Palomo       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 152 |
      | Diastole | 98  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuarterAgo" with following data
      | Systole  | 138 |
      | Diastole | 83  |
  #
  #  Patient 11 -  Patient under care, TEI under care registered before the past 3 months and controlled visit in following quarter
  #
    And I create a new TEI on "3_QuartersAgo" for this Facility with the following attributes
      | Given name         | Iverna       |
      | Family name        | Terrazas     |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 42           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_QuartersAgo" with following data
      | Systole  | 146 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo" with following data
      | Systole  | 143 |
      | Diastole | 93  |
    And That TEI has a "Hypertension & Diabetes visit" event on "2_QuartersAgo_Plus_1_Month" with following data
      | Systole  | 138 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_QuarterAgo" with following data
      | Systole  | 137 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_QuarterAgo_Plus_1_Month" with following data
      | Systole  | 135 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "thisQuarter" with following data
      | Systole                         | 130      |
      | Diastole                        | 81       |
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 200      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "thisQuarter_Plus_1_Month" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "thisQuarter_Plus_1_Month_15_Days" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 100      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    When I wait for 1 second
    And I export the analytics

    Then The value of "PI":"HTN - Total patient registrations in previous quarter" with period type "Quarters" should be
      | 4_QuartersAgo | 1 |
      | 3_QuartersAgo | 2 |
      | 2_QuartersAgo | 4 |
      | 1_QuarterAgo  | 2 |
      | thisQuarter   | 0 |
    Then The value of "PI":"HTN - Patients with controlled BP at latest visit in this quarter" with period type "Quarters" should be
      | 4_QuartersAgo | 0 |
      | 3_QuartersAgo | 1 |
      | 2_QuartersAgo | 2 |
      | 1_QuarterAgo  | 1 |
      | thisQuarter   | 0 |
    Then The value of "PI":"HTN - Patients with uncontrolled BP from latest visit in this quarter" with period type "Quarters" should be
      | 4_QuartersAgo | 1 |
      | 3_QuartersAgo | 1 |
      | 2_QuartersAgo | 1 |
      | 1_QuarterAgo  | 0 |
      | thisQuarter   | 0 |
    Then The value of "PI":"HTN - Patients with no visit in this quarter" with period type "Quarters" should be
      | 4_QuartersAgo | 0 |
      | 3_QuartersAgo | 0 |
      | 2_QuartersAgo | 1 |
      | 1_QuarterAgo  | 1 |
      | thisQuarter   | 0 |
