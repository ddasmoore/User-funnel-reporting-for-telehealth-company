# User-funnel-reporting-for-telehealth-company
 
  ## Table of Contents
* [About the project](#About-the-project)
* [Executive summary of insights](#Executive-summary-of-insights)
* [Technical Details and detailed insights](#Technical-Details-and-detailed-insights)
  *   [About the dataset](#About-the-dataset)
  *   [Tools and libraries](#Tools-and-libraries)
  *   [Data analysis](#Data-analysis)
  *   [Results](#Results)
  *   [Recommendations](#Recommendations )

## About-the-project
This project shares user funnel insights for a dermatological telehealth website. When users sign up on the website, they first schedule a telehealth appointment with a dermatologist where they are given skincare regimen recommendations.
Following this appointment, users can purchase products that are shipped to them on a quarterly basis. 

The goal of this project was two fold:
1) Generate user funnel insights capturing weekly statistics for each step in the user journey from sign up to first appointment, from first appointment to first order, total value of first order and turnaround time for each step
2) Create a dashboard that enables mornitoring any delays or inefficiencies in the user sign up journey that could impact user experience or revenue. 

## Executive-summary-of-insights
1) Roses: Overall user acquistion increased from January to April. Convertion rates from sign up to first appointment is generally robust with 89%-100% of users who sign up are also completing their first appointment.
3) Thorns: Average days from sign up to first appointment showed an increasing trend from January to April, suggesting that user activation . Average order value of the first order also declined from January to April.

<img width="1756" height="961" alt="image" src="https://github.com/user-attachments/assets/0c3974bc-5c26-4083-9231-b64f3ac146dd" />


## Technical-Details-and-detailed-insights

## About-the-dataset
The dataset consists of three tables: 
1) **users** containing user id and sign up date
2) **appointments** containing user id, appointment status and timestamps
3) **rx_orders** tracking orders placed by the users.
The analysis focused on creating a user journey funnel capturing sign up to appointment to first order as well as weekly statistics capturing average turnaround times between each step.

## Tools-and-libraries
The data was analyzed using SQL in Snowflake.

## Data-analysis
The analysis consisted of 3 main steps:
1) **Data cleaning**

Data quality was checked to eliminate any data inconsistencies and to identify missing values. Null user_id were identified in the appointment table and they were excluded from analyses going forward.
No duplicate user_ids were found. Data types were changed to make it easier to reference them later in the analysis e.g., type cast dates into date variable type.

![image](https://github.com/user-attachments/assets/c4c1bdab-cef1-45c3-85c9-5331fd445f65)

2) **Create a user funnel**

To create the user funnel following steps were taken:
Started with clean data (excluding any null user_ids) and used a ROW_NUMBER function to rank all appointments (scheduled, completed) to find the completed appointment dates. The first completed appointment per user (users can have multiple appointments every 3 months) was identified. 

![image](https://github.com/user-attachments/assets/b3a32a20-f86a-4757-8abb-245b36e0afcd)

DENSE_RANK was used to find the first prescription order after the completed appointment per user. The order total per user was computed.

![image](https://github.com/user-attachments/assets/b1fe9d9c-4130-46de-bede-4e0123754cc3)

Joined user id, sign up date, completed first appointment and order date and order total together so that turnaround times (TAT) between sign up and appointment and between appointment and order dates were calculated at the final step in creating the user journey.

  ![image](https://github.com/user-attachments/assets/6d9b2864-9b8a-4e59-9ab9-76af9989c252)

3) **Calculate weekly statistics**
   
Aggregated the data from the user journey above to calculate average turnaround times (TAT) and conversion rates

![image](https://github.com/user-attachments/assets/54403df3-02d0-489b-bde4-749e066ac01c)


## Results
The week over week user signup to order funnel captured inefficiencies in the user journey funnel such as increased user activation period from January to April and decline in first order value during the same period. 

<img width="1782" height="396" alt="image" src="https://github.com/user-attachments/assets/77b39391-1131-484e-bbd7-d696bf53a9a5" />

Detailed findings:
1) User acquisition increased steadily from January to April. 
2) The average days from sign up to the first appointment showed an increasing trend for cohorts from January to Aril. January cohort took 25 says, March took 49.82 days and April took 48.4 days from sign up to completed first appointment.
   This suggested that the user activation was taking longer. 
3) Conversion rate was generally robust with 89%-100% of users who signed up were completing their first appointment week over week.
4) Average days to first order after completed appointment ranged from ~4 to ~10 days, with an average of ~7.5 days. 
5) There was some drop off among users who completed an appointment and those who purchased their first order. In the last two weeks with >100 signed up users, the conversion rate seemed strong with >82% of users purchasing an order. 
6) The average value of the first order declined from January ($194) to April cohort ($151.58)
  


## Recommendations 
Findings support the following:
1) Ucovering causes of delay from sign up to first appointment. Potential pain points include friction in signup to booking flow, users forgetting to schedule appointments or not seeing enough appointment availability.
2) Monitoring conversion rate from first appointment to making an order using week over week sign up funnel to track whether the conversion remain the same or decline further.
3) Investigation of declining average first order value from January to April as this impacts revenue. This decline may be correlated with the increase in time from sign up to first appointment, customer dissatisaction with first appoinment or both. Potential solutions include making sure
   dermatoglist appointments are not backlogged and customers see available appointments, collecting feedback after first appointment to see if customer experience can be improved, testing introductory offers for new users to encourage higher initial spend.


