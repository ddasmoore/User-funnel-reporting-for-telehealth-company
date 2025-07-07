CREATE VIEW WORKSPACE_DIPANJANA.PUBLIC.firt_user_journey_weekly AS(
    SELECT 
        user_signup_week,
        COUNT(user_id) AS users_signed_up,
        AVG(first_appointment_tat) AS avg_days_to_first_appointment,
        1.0* count(first_appointment_tat)/ COUNT(user_id) AS pct_users_with_appointment,
        AVG(first_rx_order_tat) AS avg_days_to_first_rx_order,
        1.0* COUNT(first_rx_order_number)/COUNT(user_id) AS pct_users_with_rx_orders,
        AVG(first_order_value) AS avg_first_order_value
    FROM WORKSPACE_DIPANJANA.PUBLIC.first_user_journey
    GROUP BY 1
    ORDER BY 1 DESC
);