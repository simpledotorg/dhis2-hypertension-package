# <a name="_w36ztzc2mcoz"></a>Hypertension and Diabetes Registry System Design
### <a name="_gm8m7r6dq5cc"></a>Introduction
#### <a name="_d6m7qtelmhzt"></a>Purpose
This Hypertension and Diabetes Registry System Design Guide provides an overview of the reasoning and design used to configure a DHIS2 tracker program for registering and managing patients with hypertension and/or diabetes. This document is intended for use by DHIS2 implementers at country and regional level to support implementation and localization of the package. Local work flows and national guidelines should always be considered in the localization and adaptation of this configuration package.
#### <a name="_sehzreqhlnrs"></a>Background
Hypertension or elevated blood pressure is a serious medical condition that significantly increases the risks of diabetes, heart, brain, kidney and other diseases. According to the WHO, an estimated 1.28 billion adults aged 30-79 years worldwide have hypertension, most (two-thirds) living in low- and middle-income countries. Only 1 in 5 adults (21%) with hypertension have their blood pressure under control <sup>1</sup>. Diabetes is also a leading cause of death and disability worldwide, affecting 0.5 billion people worldwide have diabetes, the majority in low- and middle-income countries <sup>2</sup>. 

Given the high prevalence and co-morbidity of hypertension and diabetes, they are often treated together in primary care settings. Having a single digital tool to manage these patients is critical.

This Hypertension and Diabetes package is based on the DHIS2 Tracker program deployed in Nigeria since 2021 (in collaboaration with the Federal Ministry of Health Nigeria, National Primary Health Care Development Agency, HISP-Nigeria, WHO and Resolve to Save Lives). Indicators for the package were derived from the WHO HEARTS Technical package for hypertension management and WHO guidelines for diabetes.

As of May 2024, over 30,000 hypertensive and diabetes patients are being managed across over 104 primary healthcare facilities with this DHIS2 Tracker program. The Nigeria program is based on the design of the [Simple App](https://www.simple.org/), a custom mobile application developed by RTSL and deployed in 4 countries, with 4 million patients enrolled for hypertension and diabetes care as of June 2024.

Before the [Nigeria Hypertension Control Initiative](https://www.afro.who.int/news/nigeria-collaborates-who-curb-hypertension-introduces-control-initiative) (NHCI), there were no tools to track the management of hypertension and diabetes patients and only suspected cases were recorded in the national DHIS2 instance. NHCI first introduced paper-based tools for tracking and monitoring these patients over time, but this approach had several issues. It increased the workload and placed the burden on frontline workers, and data quality challenges (data inconsistencies, missing data, summation errors, untimely data) denying program managers and policy makers accurate data for decision making. These factors led to the deployment of DHIS2 Tracker across the NHCI supported facilities in Kano and Ogun state.

The key goal of this package is to improve data timeliness and accuracy, enhance data use for decision making and scale efficient hypertension management at primary health care level. Like the Simple App, it strives for a minimal dataset on routine hypertension and diabetes care to improve facility-level analysis, while minimizing reporting burden on care providers.
### <a name="_h370s9deefxc"></a>System Design Overview
#### <a name="_t84mm139ir6o"></a>Use Case
![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.001.jpeg)

*Nigeria healthcare worker using DHIS2*

The principal end users of this system are care providers at primary health centers who see patients for monthly hypertension and diabetes services. Since hypertension and diabetes generally affects a broad proportion of the population, in many contexts care providers have little time to enter detailed data on hypertension and diabetes patient encounters. Therefore the focus is on collecting a *limited set of data elements* to produce three key indicators: percent of patients with controlled blood pressure/blood sugar, percent of patients with uncontrolled blood pressure/blood sugar, and percent of patients with missed monthly visits.

These indicators can be monitored on the facility level or at higher district and national levels on dashboards (see below). Aggregate outputs can later be pushed into a national HMIS instance.

Other data elements collected are instrumental for hypertension and diabetes management. For example, providers enter hypertension and diabetes treatments and medications provided. However, patients must be diagnosed with hypertension and/or diabetes in order to be enrolled in the program.

Because primary health care centres often lack reliable internet, the tracker is designed for offline data capture with the DHIS2 Android app. It can also be run in the browser with the DHIS2 Tracker Capture app.

![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.002.png)

*Design Diagram*
#### <a name="_qshmp6w3npuq"></a>Rationale for program structure
The fundamental goal of the program is for clinicians to record monthly blood pressure/blood sugar readings, medication and schedule next visits quickly. This provides clinicians critical information to manage their patients with hypertension/diabetes over time. The data collected are only needed to identify patients and manage hypertension/diabetes, and should be entered as quickly as possible.

However, the Hypertension and Diabetes Registry could be expanded to cover related Non-Communicable diseases (NCDs) such as CVD. This is particularly useful in scenarios where comorbidities are frequently monitored and managed by the clinician during a hypertension visit, like cardiovascular disease.

When adapting the program for local use, diagnosis of such these other NCDs could therefore be considered eligibility for enrollment into what is currently the ‘Hypertension Registry'. Therefore, a Tracked Entity Attribute for ‘Does this patient have hypertension?’ is autofilled as ‘Yes’ during enrollment, and program indicators for hypertension reporting require this value. The approach gives an implementation flexibility to augment the program with other NCDs after roll-out has started.

Furthermore, laboratory tests, generally performed asynchronously with facility visits, can also be added as new program stages.
### <a name="_dwju7zy2yt7s"></a>Program Configuration
#### <a name="_wejkxyameqvu"></a>Registration
For a new patient to be registered into the DHIS2 Hypertension and Diabetes registry, the user will first enter a number of Tracked Entity Attributes in the enrollment page. Tracked Entity Attributes gather personal identifiable information (such as name, date of birth, ID number) for the purposes of patient search and validation. In the Hypertension and Diabetes Registry program, sixteen Tracked Entity Attributes are included, but only four are made searchable as identifiers. The full list is available in the Metadata Reference file.

|**Registration start**|**Registration end**|
| :- | :- |
|![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.003.png)|![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.004.png)|


Seven fields are mandatory to enter during registration, noted with \*

- **Name:** The patient name (both **first name** and **last name**) is required as a potential identifier for the patient’s record over time
- **Date of birth**. If the patient does not know his or her date of birth, then the care provider should enter the patient’s age. Entering date of birth under 10 years old and over 140 years old displays an error. After entering the date of birth, the *current* age is calculated as a program indicator and displayed in the indicators widget
- **District:** If the patient does not know their exact address, at a minimum the patient must provide the district the patient currently lives in. If not known, the care provider may use the district the health facility is located in
- **Does the patient have hypertension/diabetes?:** Only patients diagnosed with hypertension/diabetes should be registered in the program
- **Consent to record data**. The patient must give their consent to electronically record their personal data before saving the enrollment. This is noted with a mandatory yes-only tracked entity attribute.

QR codes that are stuck on patient appointment cards and recorded as a Tracked Entity Attribute can be used to easily search for a patient during a follow-up visit.

The history of cardiovascular and kidney disease for a patient is recorded to inform patient treatment. 

NB: since these demographic and identifier data are often reusable across tracker programs, the tracked entity attributes can be shared by multiple DHIS2 Tracker packages. Those metadata are found in the [Common Metadata Library](https://docs.dhis2.org/en/topics/metadata/dhis2-who-digital-health-data-toolkit/common-metadata-library/design.html) (and are prefixed with “GEN -” in the attribute name).

After the user clicks Save icon, the patient is considered enrolled in the Hypertension and Diabetes Registry, and the first Hypertension/Diabetes Visit event immediately opens.
#### <a name="_ml3fn9qj5i9s"></a>Hypertension & Diabetes Visit
The main stage in the program is the Hypertension/Diabetes visit (HTN/DM visit). This is assumed to repeat every month after enrollment.

There are three optional sections in a visit:

1. **Hypertension record:** Systolic and diastolic blood pressure is recorded. Invalid blood pressure values (systolic reading of below 60 or above 260, diastolic reading of below 40 or above 260) are prohibited by program rules
1. **Diabetes record:** Type of blood sugar measure, unit and reading is recorded. The care provider can choose between random blood sugar, fasting blood sugar, post prandial blood sugar and HbA1c
1. **Medicines:** Captures the current hypertension and diabetes medication prescribed. Each implementation can customize the medication list based on their treatment protocol. Previously entered medication is listed in the program indicators widget and number of days since the most recent HTN visit

At the end of this section, the care provider can schedule the next visit date for the patient. This is defaulted to 28 days from the current visit date and based on most patients being provided a month's supply of medication. If the patient receives medication for multiple months, the care provider can change the date of the next visit accordingly.

|**Hypertension record**|**Medicines**|
| :- | :- |
|<p>![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.005.png)</p><p></p><p></p>|![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.006.png)|

*Enter HTN/DM visit details*
<a name="_h20g9xurnphw"></a>


Calling report
----------------------------
This stage in the program is only visible for patients that are overdue (i.e. have missed a scheduled HTN/DM visit). The purpose of this stage is for care providers to call overdue patients and record the call outcome (i.e. whether a patient agrees to return to care, is not reachable, should be removed from the overdue list).

The care provider can view a line list of overdue patients using the pre-configured working lists. The care provider should sync with the backend to have up-to-date patient lists on their devices. Refer to the installation guide for more info. Working lists in the app include:

- Overdue - 1. Pending to call: List of overdue patients that are yet to be called
- Overdue - 2. Agreed to visit: List of overdue patients that have been called and agreed to visit
- Overdue - 3. Remind to call later: List of overdue patients that were called but need a follow-up call (e.g. were busy, did not pick up)
- Overdue - 4. Remove from list: List of overdue patients that were called and need to be removed from overdue list (full list of reasons available in metadata reference file)

NB. An overdue patient is no longer overdue only when they return to care for a HTN/DM visit 
#### <a name="_ratd9vr07g5"></a>Closing the record
If a patient is no longer being seen by the health facility, it is important to update the patient status, which will remove the patient’s record from the denominators of key performance indicators.

When calling overdue patients, the care provider may encounter individuals no longer expected at the health facility, whether due to death or transfer to another facility. To record this change in the program, in the calling report, the care provider can update the call outcome as removed from overdue list and the corresponding reason (e.g. died, moved to private practitioner, transferred to another public health facility). A program rule will update the patient status and remove these patients from key performance indicators.

### <a name="_g6te6cmmtayw"></a>Monthly summary form (aggregate reports)
At health facility level, the monthly summary form can be used to collect data on drug stock, medical device inventory and hypertension screening. At the end of each month, a care provider can record the number of adults screened for hypertension that month, the number of tablets of each medication remaining and functioning BP monitors.
### <a name="_i1u71pdlcl7x"></a>Dashboards
Two dashboards are included in this package, the **Hypertension** and **Diabetes Dashboards**. These dashboards provide an overview of key indicators for hypertension and diabetes treatment outcomes. The dashboard can be viewed as a high-level program administrator user or at a local facility level.

Definitions for the dashboard indicators are closely based on definitions for reporting of [aggregate data from the Simple app](https://docs.simple.org/reports/what-we-report) as well as the [WHO HEARTS Technical Package](https://www.who.int/publications/i/item/9789240001367). The definitions are included below, and in a text box at the bottom of the dashboard.

Each dashboard is divided into the following sections:
#### <a name="_rwjms6p79wup"></a>Treatment outcomes
![ref1]

*Dashboard - treatment outcomes*

The first three charts display treatment outcomes related to blood pressure/blood sugar control of patients under care. Blood pressure/blood sugar control is the best indicator to know if patients under treatment are being treated effectively. These three charts consider a patient’s latest visit within the last three months for all active patients registered before the past three months. Patients registered within the last three months are excluded, as three months gives patients time to take their hypertension/diabetes medication and to get their blood pressure/blood sugar under control. Most newly registered patients have uncontrolled blood pressure/blood sugar and including them would not reflect an accurate picture of actual controlled patients.

The three charts within the treatment outcomes section are based on the following indicators:

|**Indicator**|**Hypertension dashboard**|**Diabetes dashboard**|
| :- | :- | :- |
|<p>% Patients controlled</p><p></p><p></p>|Patients under care in the hypertension control program (registered before the last 3 months) that visited a health facility in the past 3 months with a BP measure <140/90 at their latest visit|Patients under care in the diabetes control program (registered before the last 3 months) that visited a health facility in the past 3 months with controlled blood sugar (FBS < 126mg/dL or HbA1c <7%) at their latest visit|
|% Patients uncontrolled|Patients under care in the hypertension control program (registered before the last 3 months) that visited a health facility in the past 3 months with a BP measure ≥140/90 at their latest visit|Patients under care in the diabetes control program (registered before the last 3 months) that visited a health facility in the past 3 months with uncontrolled blood sugar (FBS ≥126mg/dL or HbA1c ≥7%) at their latest visit|
|% Patients no visit in past 3 months|Patients under care in the hypertension control program (registered before the last 3 months) with no visit (no BP measure recorded) in the past 3 months |Patients under care in the diabetes control program (registered before the last 3 months) with no visit (no blood sugar recorded) in the past 3 months |
####
#### <a name="_qns3d6mmvdxf"></a><a name="_4uewnj3sow1l"></a>Registrations, patients under care, lost to follow-up and treatment cascade
![ref2]

*Dashboard - registrations, patients under care, lost to follow-up, treatment cascade*

The next section highlights registrations (how many patients are enrolled in a hypertension/diabetes control program) and how many of those patients are “under care” (have visited in the last 12 months). Patients that have not visited in the last 12 months (i.e. no BP measure/blood sugar recorded in the last 12 months) are recorded as lost to follow-up.

The treatment cascade provides a view of how many expected individuals in a region are under treatment for hypertension/diabetes and, of those patients, how many have their BP/blood sugar under control.

|**Indicator**|**Hypertension dashboard**|**Diabetes dashboard**|
| :- | :- | :- |
|**Registrations**|||
|Patient registrations (Monthly)|New patients registered in the hypertension control program in a month|New patients registered in the diabetes control program in a month|
|<p>Patient </p><p>registrations (Cumulative)</p>|Cumulative registrations in the hypertension control program (excluding dead patients)|Cumulative registrations in the diabetes control program (excluding dead patients)|
|Patients under care|Cumulative registrations in the hypertension control program excluding 12 month lost to follow-up and dead patients|Cumulative registrations in the diabetes control program excluding 12 month lost to follow-up and dead patients|
|**Lost to follow-up**|||
|% 12 month lost to follow-up|Patients with no "visit" in the past 12 months (i.e. no BP measure recorded in the past 12 months)|Patients with no "visit" in the past 12 months (i.e. no blood sugar measure recorded in the past 12 months)|
|**Treatment cascade**|||
|Estimated people|Estimated adults ≥30 with hypertension reported from WHO [STEPS community surveys](https://www.who.int/teams/noncommunicable-diseases/surveillance/systems-tools/steps)|Estimated adults ≥30 with diabetes reported from WHO [STEPS community surveys](https://www.who.int/teams/noncommunicable-diseases/surveillance/systems-tools/steps)|
|% of people registered|Number of patients in the region registered in the hypertension control program|Number of patients in the region registered in the diabetes control program|
|% of people under care|Number of patients in the region registered in the hypertension control program who have visited a facility at least once in the past 12 months|Number of patients in the region registered in the diabetes control program who have visited a facility at least once in the past 12 months|
|% of people controlled|Number of patients in the region registered in the hypertension control program who have their BP controlled at the most recent visit within the past 3 months|Number of patients in the region registered in the hypertension control program who have their blood sugar controlled at the most recent visit within the past 3 months|
####
#### <a name="_tm11pwir4bou"></a><a name="_vq6v73pgk4y5"></a>Sub-region comparisons and quarterly cohort reports
![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.009.png)![](./07eb2319-3c1e-4d5d-97c8-fe084d826934.010.png)

*Dashboard - sub-region comparisons, quarterly cohort reports*

The sub-region comparisons repeat information from the previous two sections at the sub-national level for the last month. This is useful for a higher-level user (at district or regional level) to assess outcomes across facilities. 

The quarterly cohort report allows program managers to track onboarding and initial treatment outcomes for cohorts of newly registered patients. The reports take all patients registered during a quarter and displays the outcome of their visit in the following quarter. For example, the April-June quarterly cohort refers to treatment outcomes for patients registered in January-March. The quarterly cohort report indicators are:

|**Indicator**|**Hypertension dashboard**|**Diabetes dashboard**|
| :- | :- | :- |
|<p>% Patients controlled</p><p></p><p></p>|The number of patients with a BP <140/90 at their last visit in the quarter after the quarter when they were registered|The number of patients with controlled blood sugar (FBS < 126mg/dL or HbA1c <7%) at their last visit in the quarter after the quarter when they were registered|
|% Patients uncontrolled|The number of patients with a BP ≥140/90 at their last visit in the quarter after the quarter when they were registered|The number of patients with uncontrolled blood sugar (FBS ≥126mg/dL or HbA1c ≥7%) after the quarter when they were registered|
|% Patients no visit in past 3 months|The number of patients with no visit in the quarter after the quarter when they were registered |The number of patients with no visit in the quarter after the quarter when they were registered |
|Quarterly registrations|The number of new patients registered in the hypertension control program in a quarter|The number of new patients registered in the diabetes control program in a quarter|

#### <a name="_2tuuuo9ydpk1"></a>Drug stock and inventory reports
The last section of the dashboard refers to the stock level of anti-hypertensive medication and BP monitor inventory. Program managers can view the proportion of facilities with >30 patient days of drug stock for treatment protocol drug groups (Amlodipine, Hydrochlorothiazide, Losartan). The drug stock and inventory stock can be viewed at facility level. The drug stock and inventory indicators are:

|**Indicator**|**Hypertension dashboard**|
| :- | :- |
|<p>% Facilities with >30 patient days of a drug (e.g. Amlodipine)</p><p></p><p></p>|<p>Facilities with >30 patient days worth of supply for a drug.</p><p></p><p>Patient days of a drug is the ratio of the number of tablets at-hand in comparison to the estimated proportion of patients on the drug registered at the facility.</p>|
|% Facilities reporting drug stock|Proportion of facilities reporting drug stock and inventory data|

### <a name="_2x13yusodwj0"></a>User groups
The users are assigned to the appropriate user group based on their role within the system. Sharing for other objects in the package may be adjusted depending on the set up. Refer to the [DHIS2 Documentation on sharing](https://docs.dhis2.org/en/topics/metadata/crvs-mortality/rapid-mortality-surveillance-events/installation.html#sharing) for more information.

|**User group**|**Dashboard**|**Program metadata**|**Program data**|
| :- | :- | :- | :- |
|HTN admin|Can edit and view|Can edit and view|No access|
|HTN access|Can edit and view|Can view only|Can view only|
|HTN data capture|Can view|Can view only|Can capture and view|
## <a name="_x5yk6zisvo3s"></a>References
-----
1. World Health Organization (25/08/2021). Hypertension Key Facts. Retrieved from: <https://www.who.int/news-room/fact-sheets/detail/hypertension> (Accessed on 19/09/2022) [↩](https://docs.dhis2.org/en/implement/health/non-communicable-diseases/hypertension-control/design.html#fnref:first)
1. Global Burden of Disease 2021: Findings from the GBD 2021 Study. Retrieved from: <https://www.healthdata.org/research-analysis/library/global-burden-disease-2021-findings-gbd-2021-study> (Accessed on 02/07/2024)

[ref1]: ./07eb2319-3c1e-4d5d-97c8-fe084d826934.007.png
[ref2]: ./07eb2319-3c1e-4d5d-97c8-fe084d826934.008.png
