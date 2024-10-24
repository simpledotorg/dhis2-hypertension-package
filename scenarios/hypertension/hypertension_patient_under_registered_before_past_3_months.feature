Feature: Audit the program indicator: HTN - Patients under care registered before the past 3 months

  Scenario: All TEIs must be hypertensive
    Given I create a new OrgUnit
    And I assign the current user to the current orgUnit
    And I register that Facility for program "Hypertension & Diabetes"
    
    #
    # Patient 1 - Not a hypertension TEI
    #
    And I create a new TEI on "7_MonthsAgo" at this organisation unit with the following attributes
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
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 206      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 134      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 133      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    #
    # Patient 2
    #
    And I create a new TEI on "7_MonthsAgo" at this organisation unit with the following attributes
      | Given name         | Sue          |
      | Family name        | Perkins      |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | v4DnYfXn9Mu        | YES          |
      | NI0QRzJvQ0k        | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |

    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    When I wait for 1 second
    And I export the analytics

    # NOTE the PI name has a '.' at the end.
    Then The value of "PI":"HTN - Patients under care registered before the past 3 months." with period type "Months" should be
      | 1_MonthAgo   | 1 |
      | 2_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 1 |
      | 4_MonthsAgo  | 1 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 0 |
      | 8_MonthsAgo  | 0 |
      | 9_MonthsAgo  | 0 |
      | 10_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 12_MonthsAgo | 0 |

  Scenario: All dead TEIs are excluded
    And I create a new OrgUnit
    And I assign the current user to the current orgUnit
    And I register that Facility for program "Hypertension & Diabetes"
    #
    # Patient 1 -Dead
    #
    And I create a new TEI on "6_MonthsAgo" for this Facility with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | YES          |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 200      |
      | HTN - Blood sugar unit          | MG_OR_DL |


    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | HTN - Type of diabetes measure? | FBS      |
      | HTN - Blood sugar reading       | 130      |
      | HTN - Blood sugar unit          | MG_OR_DL |

    And That TEI was updated on "1_MonthAgo" with the following attributes
      | HTN - NCD Patient Status | DIED |

    #
    # Patient 2
    #
    And I create a new TEI on "7_MonthsAgo" at this organisation unit with the following attributes
      | Given name         | Sue          |
      | Family name        | Perkins      |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | v4DnYfXn9Mu        | YES          |
      | NI0QRzJvQ0k        | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |

    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    When I wait for 1 second
    And I export the analytics

    # NOTE the PI name has a '.' at the end.
    Then The value of "PI":"HTN - Patients under care registered before the past 3 months." with period type "Months" should be
      | 1_MonthAgo   | 1 |
      | 2_MonthsAgo  | 1 |
      | 3_MonthsAgo  | 1 |
      | 4_MonthsAgo  | 1 |
      | 5_MonthsAgo  | 0 |
      | 6_MonthsAgo  | 0 |
      | 7_MonthsAgo  | 0 |
      | 8_MonthsAgo  | 0 |
      | 9_MonthsAgo  | 0 |
      | 10_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 12_MonthsAgo | 0 |

  Scenario: All TEIs must be registered before 3 months
    Given I create a new OrgUnit
    And I assign the current user to the current orgUnit
    And I register that Facility for program "Hypertension & Diabetes"
    #
    # Patient 1
    #
    And I create a new TEI on "10_MonthsAgo" for this Facility with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | NO           |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "10_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 95  |
    And That TEI has a "Hypertension & Diabetes visit" event on "8_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    #
    # Patient 2
    #
    And I create a new TEI on "7_MonthsAgo" at this organisation unit with the following attributes
      | Given name         | Sue          |
      | Family name        | Perkins      |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | v4DnYfXn9Mu        | YES          |
      | NI0QRzJvQ0k        | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |

    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "6_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    When I wait for 1 second
    And I export the analytics

    # NOTE the PI name has a '.' at the end.
    Then The value of "PI":"HTN - Patients under care registered before the past 3 months." with period type "Months" should be
      | 1_MonthAgo   | 2 |
      | 2_MonthsAgo  | 2 |
      | 3_MonthsAgo  | 2 |
      | 4_MonthsAgo  | 2 |
      | 5_MonthsAgo  | 1 |
      | 6_MonthsAgo  | 1 |
      | 7_MonthsAgo  | 1 |
      | 8_MonthsAgo  | 0 |
      | 9_MonthsAgo  | 0 |
      | 10_MonthsAgo | 0 |
      | 11_MonthsAgo | 0 |
      | 12_MonthsAgo | 0 |

  Scenario: All TEIs who have their last visit before 12 months must be excluded
    Given I create a new OrgUnit
    And I assign the current user to the current orgUnit
    And I register that Facility for program "Hypertension & Diabetes"
    #
    # Patient 1
    #
    And I create a new TEI on "7_MonthsAgo" at this organisation unit with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | NO           |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |

    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "3_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    #
    # Patient 2
    #
    And I create a new TEI on "10_MonthsAgo" at this organisation unit with the following attributes
      | Given name         | Joey         |
      | Family name        | Joseph       |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | v4DnYfXn9Mu        | NO           |
      | NI0QRzJvQ0k        | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |

    And That TEI has a "Hypertension & Diabetes visit" event on "10_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |
    And That TEI has a "Hypertension & Diabetes visit" event on "8_MonthsAgo" with following data
      | Systole  | 142 |
      | Diastole | 87  |
    And That TEI has a "Hypertension & Diabetes visit" event on "7_MonthsAgo" with following data
      | Systole  | 140 |
      | Diastole | 83  |
    And That TEI has a "Hypertension & Diabetes visit" event on "5_MonthsAgo" with following data
      | Systole  | 135 |
      | Diastole | 84  |
    And That TEI has a "Hypertension & Diabetes visit" event on "1_MonthAgo" with following data
      | Systole  | 134 |
      | Diastole | 83  |

    #
    # Patient 3
    #
    And I create a new TEI on "18_MonthsAgo" for this Facility with the following attributes
      | Given name         | Fabian       |
      | Family name        | Moore        |
      | Sex                | MALE         |
      | HTN diagnosis      | YES          |
      | DM diagnosis       | NO           |
      | Date of birth      | 32           |
      | Address            | Rose Gardens |
      | District           | KOLARA       |
      | Data consent       | true         |
      | NCD Patient Status | ACTIVE       |
    And That TEI has a "Hypertension & Diabetes visit" event on "18_MonthsAgo" with following data
      | Systole  | 147 |
      | Diastole | 89  |

    When I wait for 1 second
    And I export the analytics

    # NOTE the PI name has a '.' at the end.
    Then The value of "PI":"HTN - Patients under care registered before the past 3 months." with period type "Months" should be
      | thisMonth    | 2 |
      | 1_MonthAgo   | 2 |
      | 2_MonthsAgo  | 2 |
      | 3_MonthsAgo  | 2 |
      | 4_MonthsAgo  | 2 |
      | 5_MonthsAgo  | 1 |
      | 6_MonthsAgo  | 1 |
      | 7_MonthsAgo  | 2 |
      | 8_MonthsAgo  | 1 |
      | 9_MonthsAgo  | 1 |
      | 10_MonthsAgo | 1 |
      | 11_MonthsAgo | 1 |
      | 12_MonthsAgo | 1 |
