 Feature: Audit the PI - HTN PUC registered before 3 months and is controlled in the last 3 months
  ____
  As a tester
  Given I have a few tracked entity instances with event history in the system
  When  I export the analytics and run the hypertension data aggregation
  Then  I should see the "HTN PUC registered before 3 months and is controlled in the last 3 months" program indicator data for each month as expected
  ____

 Scenario: All patients should be hypertensive
  Given I create a new OrgUnit
  And I assign the current user to the current orgUnit
  And I register that Facility for program "Hypertension & Diabetes"
  And I create a new TEI on "7_MonthsAgo" for this Facility with the following attributes
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
  And That TEI has a "Hypertension & Diabetes visit" event on "7_monthsAgo" with following data
   | HTN - Type of diabetes measure? | FBS      |
   | HTN - Blood sugar reading       | 130      |
   | HTN - Blood sugar unit          | MG_OR_DL |

  Scenario: All patients should have a visit in the last 12 months
 Scenario: The last visit has to be controlled

