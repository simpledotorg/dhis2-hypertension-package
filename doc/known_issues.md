# Known issues

List of known issues with DHIS2 and the package. **None** of the issues listed below are critical or will block an implementation of the package

## DHIS2 limitations
- Adding a new event to a stage in Web Capture [issue](https://dhis2.atlassian.net/browse/DHIS2-16885)
- Incorrect SQL formatter for an indicator [issue](https://dhis2.atlassian.net/browse/DHIS2-17789)


## Package limitations
- If a patient visits with no BP or blood sugar reading taken, the patient should be counted in the missed visit indicator. A visit is defined as a patient having a BP or blood sugar reading was taken. In the current package, the patient is not considered as a missed visit and instead the most recent visit with a BP or blood sugar reading is considered (making the patient either BP/blood sugar controlled or BP/blood sugar uncontrolled).
