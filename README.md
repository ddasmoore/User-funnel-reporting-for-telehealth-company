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
The goal of this project is to generate user funnel insights for a dermatological telehealth company called GlowRx. When users sign up to  GlowRx, they first have a telehealth appointment with a dermatologist where they are given skincare regimen recommendations.
Following this appointment, users purchase products that are shipped to them on a quarterly basis. I conducted 2 main analyses:
1) Funnel report capturing each step in the user journey from sign up to first appointment, from first appointment to first order, total value of first order and turnaround time for each step
2) Weekly statistics report capturing average turnaround times between each step and the total number of users signed up per week.
These analyses will allow GlowRx to spot delays or inefficiency in new user sign up journeys to be able to optimnize user experience and increase revenue.


## Executive-summary-of-insights
1) Roses: Overall user acquistion has increased from January to April. Convertion rates from sign up to first appointment is generally robust with 89%-100% of users who sign up are also completing their first appointment.
3) Thorns: Average days from sign up to first appointment shows an increasing trend from January to April, suggesting that user activation is taking longer. Average order value of the first order has also declined from January to April.

## Technical-Details-and-detailed-insights

## About-the-dataset
The dataset consists of three tables: 
1) users containing user id and sign up date
2) appointments containing user id, appointment status and timestamps
3) rx_orders tracking orders placed by the users.
The analysis focused on creating a user journey funnel capturing sign up to appointment to first order as well as weekly statistics capturing average turnaround times between each step.

## Tools-and-libraries
I analyzed the data using SQL in Snowflake.

## Data-analysis
The analysis consisted of 3 main steps:
1) **Data cleaning**

I conducted a data quality check to check for any data inconsistencies or missing values. I checked for null user_id in the appointment table and excluded them from analyses going forward.
I checked for any duplicated user_id in the users table. No duplicates were found. I also changed data types to make it easier to reference them later in the analysis e.g., type cast dates into date variable type.
![image](https://github.com/user-attachments/assets/c4c1bdab-cef1-45c3-85c9-5331fd445f65)

2) **Create a user funnel**

To create the user funnel I took the following steps:
I took the clean data (excluding any null user_ids) and used a ROW_NUMBER function to rank all appointments (scheduled, completed) to find the completed appointment dates. I identified the first completed appointment per user (users can have multiple appointments every 3 months)
![image](https://github.com/user-attachments/assets/b3a32a20-f86a-4757-8abb-245b36e0afcd)

I used DENSE_RANK to find the first prescription order after the completed appointment per user. I computed the order total per user.
![image](https://github.com/user-attachments/assets/b1fe9d9c-4130-46de-bede-4e0123754cc3)

I joined user id, sign up date, completed first appointment and order date and total together so that I can calculate turnaround times (TAT) between sign up and appointment and between appointment and order dates at the final step in creating the user journey.
  ![image](https://github.com/user-attachments/assets/6d9b2864-9b8a-4e59-9ab9-76af9989c252)

3) **Calculate weekly statistics**
   
I aggregated the data from the user journey above to calculate average turnaround times (TAT) and conversion rates
![image](https://github.com/user-attachments/assets/54403df3-02d0-489b-bde4-749e066ac01c)


## Results
1) User acquisition is increasing steadily from January to April 2024. 
2) The average days to the first appointment shows an increasing trend for cohorts from January to March. January cohort took 25 says, March took 49.82 days and April took 48.4 days from sign up to completed first appointment.
   This suggests that the user activation is taking longer. 
3) Conversion rate is generally robust with 89%-100% of users who sign up are completing their first appointment week over week.
4) Average days to first order after completed appointment ranges from ~4 to ~10 days, with an average of ~7.5 days. 
6) There’s some drop off among users who completed an appointment and those who purchased their first order. In the last two weeks with >100 signed up users, the conversion rate seems strong with >82% of users purchasing an order. 
5) The average value of the first order is showing a decline from january ($194) to April cohort ($151.58)
   ![image](https://github.com/user-attachments/assets/4ada0dc6-9528-44ea-9a60-a9fe80b55254)


## Recommendations 
1) User acquisition strategy seems to be working well at first glance with steadily increasing user sign ups from January to April. However, without knowing what the acquisition targets are,
   it’s hard to gauge whether the company is growing as fast as expected. I would discuss acquisition targets with the company as a follow up. I would recommend analyzing acquisition numbers and costs from different marketing channels.
   
2) User activation from sign up to first completed appointment is taking longer when comparing January cohort to April cohort, which is concerning. However, it seems that despite taking longer,
   overall percentage over users activating is fairly robust. I would recommend talking with users to understand why it is taking longer to complete an appointment and address any pain points.
   Some potential pain points could be friction in signup to booking flow, users could be forgetting to schedule appointments or not seeing enough appointment availability.
  
3) There is some drop off between users completing their first appointment and making an order. I would recommend monitoring this metric for now as >82% of signed up users have completed an order in the last two weeks with
   a high volume of users signing up. We can see if this trend remains the same or declines further as more users sign up.
   
4) The declining trend in average first order value from January to April cohorts impacts revenue. It’s possible that the increased time between sign up and first completed appointment may be related to the decreasing order value for
   the first purchase made. Consider investigating user attitudes at the end of the completed appointment and how they are selecting what to purchase to see if there is a link between time to appointment, appointment satisfaction and order amount.
   Consider testing introductory offers or cross-selling items for new users to encourage higher initial spend. 
