CREATE VIEW WORKSPACE_DIPANJANA.PUBLIC.first_user_journey AS (

-- 1 data cleaning and type casting 
WITH extracted_users AS (
      SELECT USER_ID::int as USER_ID, -- converting varchar type to integer
             created_at::date as user_sign_up_date,
             DATE_TRUNC('week', created_at)::date as user_signup_week
      FROM  SQLII.RAW_DATA.USERS
),

extracted_rx_orders AS (
  SELECT 
        USER_ID::int as USER_ID,
        TRANSACTION_DATE::date as TRANSACTION_DATE,
        ITEM_CODE,
        ORDER_NUMBER,
        ITEM_AMOUNT
  FROM SQLII.RAW_DATA.RX_ORDERS
),

extracted_appointments as (
    SELECT 
        USER_ID::int as USER_ID, -- converting varchar type to integer
        APPOINTMENT_SCHEDULED_DATE::date as APPOINTMENT_SCHEDULED_DATE ,
        APPOINTMENT_DATE::date as APPOINTMENT_DATE,
        APPOINTMENT_STATUS,
        CREATED_DATE::date as CREATED_DATE,
        DATE_TRUNC('week', CREATED_DATE)::date as ROW_CREATED_WEEK
    FROM SQLII.RAW_DATA.APPOINTMENTS
    WHERE USER_ID is NOT null -- exclude invalid records
),

-- 2 rank appointments and grab latest appoitnments 
appointment_status_ranked as 
(
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY USER_ID, APPOINTMENT_DATE ORDER BY CREATED_DATE DESC) AS row_num,
    FROM extracted_appointments
),
latest_appoinment_status as(
    SELECT *
    FROM appointment_status_ranked
    WHERE row_num=1
),
/*
SELECT * FROM latest_appoinment_status
ORDER BY 1,3;
*/
-- 3 select first completed appointment 
first_appointments as(
    SELECT 
        USER_ID,
        MIN(APPOINTMENT_DATE) AS first_appointment_date_completed
    FROM latest_appoinment_status
    WHERE APPOINTMENT_STATUS='Completed'
    GROUP BY 1
),
/*
SELECT * FROM first_appointments
ORDER BY 1,2
*/

--- 4.1 first order after completed appointment 

ranked_orders AS(
    SELECT *,
        ROW_NUMBER()OVER (PARTITION BY USER_ID ORDER BY TRANSACTION_DATE, ORDER_NUMBER) AS rn,
        DENSE_RANK()OVER (PARTITION BY USER_ID ORDER BY TRANSACTION_DATE, ORDER_NUMBER) AS dr,
        RANK()OVER (PARTITION BY USER_ID ORDER BY TRANSACTION_DATE, ORDER_NUMBER) AS r
    FROM extracted_rx_orders
    ),
/*
SELECT * FROM ranked_orders
ORDER BY USER_ID, TRANSACTION_DATE, ORDER_NUMBER
*/
-- 4.2 
first_orders AS(
    SELECT 
        USER_ID,
        ORDER_NUMBER AS first_rx_order_number,
        TRANSACTION_DATE AS first_rx_order_date,
        SUM(ITEM_AMOUNT) AS first_order_value
    FROM ranked_orders
    where dr=1
    GROUP BY 1,2,3
),
/*
SELECT * FROM first_orders
ORDER BY 1
*/
-- 5.1 combine users +appointments +orders
with_orders AS(
    SELECT 
        extracted_users.user_id,
        extracted_users.user_sign_up_date,
        extracted_users.user_signup_week,
        first_appointments.first_appointment_date_completed,
        first_orders.first_rx_order_number,
        first_orders.first_order_value,
        first_orders.first_rx_order_date
    FROM extracted_users
    LEFT JOIN first_appointments on first_appointments.user_id = extracted_users.user_id
    LEFT JOIN  first_orders on first_orders.user_id = first_appointments.user_id
),
/*
SELECT * FROM with_orders
order by 1;
*/
-- 5.2 calculate TATs 
final as (
    SELECT user_id, 
		   user_sign_up_date,
           user_signup_week,
           datediff('day',user_sign_up_date,first_appointment_date_completed) as first_appointment_tat,
           first_appointment_date_completed,
           datediff('day',first_appointment_date_completed,first_rx_order_date) as first_rx_order_tat,
           first_rx_order_number,
           first_rx_order_date,
           first_order_value
    FROM with_orders
) 
select * from final
order by 1
);