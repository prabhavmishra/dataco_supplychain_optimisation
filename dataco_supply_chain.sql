select * from dataco_supply_chain

--Top 5 most expensive products
SELECT DISTINCT product_name, sales 
FROM dataco_supply_chain 
ORDER BY sales DESC 
LIMIT 5;

--Most popular Shipping Modes
SELECT shipping_mode, COUNT(*) as volume
FROM dataco_supply_chain
GROUP BY shipping_mode

--Q1.Identify which regions have the highest percentage of late deliveries and how much revenue they represent.

SELECT 
    order_region,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) AS late_orders,
    ROUND((SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS delay_rate_percentage,
    SUM(sales) FILTER (WHERE late_delivery_risk = 1) AS revenue_at_risk
FROM dataco_supply_chain
GROUP BY order_region
ORDER BY delay_rate_percentage DESC;

--Q2. The "Critical Route" Bottlenecks
--Find specific routes (City to City) where the actual shipping time is consistently 2+ days over the schedule.

WITH route_performance AS (
    SELECT 
        order_city, 
        customer_city,
        shipping_mode,
        AVG(delay_days) AS avg_delay_days,
        COUNT(*) AS total_shipments,
        MAX(delay_days) AS worst_case_delay
    FROM dataco_supply_chain
    GROUP BY order_city, customer_city, shipping_mode
)
SELECT *
FROM route_performance
WHERE avg_delay_days >= 2 
  AND total_shipments > 5 
ORDER BY avg_delay_days DESC;

--Q3.Which product categories are 'High-Reward but High-Risk'—meaning they generate the 
--highest profit per order but also suffer from the highest rates of fraud and cancellations?

WITH category_risk AS (
    SELECT 
        category_name,
        COUNT(*) AS total_orders,
        AVG(benefit_per_order) AS avg_profit,
        SUM(CASE WHEN order_status IN ('SUSPECTED_FRAUD', 'CANCELED') THEN 1 ELSE 0 END) AS risky_orders
    FROM dataco_supply_chain
    GROUP BY category_name
)

SELECT 
    category_name,
    ROUND(avg_profit::NUMERIC, 2) AS avg_profit_per_unit,
    total_orders,
    ROUND((risky_orders::NUMERIC / total_orders) * 100, 2) AS risk_percentage
FROM category_risk
WHERE total_orders > 100 -- Ignore categories with very low data
ORDER BY risk_percentage DESC;

--Q4.Determine if shipping performance is consistent across different customer segments
--(Consumer, Corporate, and Home Office). Compare the average delay days and the late delivery percentage
--for each segment to see if high-value business clients are receiving a poorer experience than general consumers.

-- Step 1: Aggregate performance metrics by customer segment
WITH segment_performance AS (
    SELECT 
        customer_segment,
        COUNT(*) AS total_orders,
        AVG(sales) AS avg_order_value,
        AVG(delay_days) AS avg_delay,
        SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) AS total_late_orders
    FROM dataco_supply_chain
    GROUP BY customer_segment
)

-- Step 2: Calculate the late rate and format the output
SELECT 
    customer_segment,
    total_orders,
    ROUND(avg_order_value::NUMERIC, 2) AS avg_revenue_per_order,
    ROUND(avg_delay::NUMERIC, 2) AS avg_days_late,
    ROUND((total_late_orders::NUMERIC / total_orders) * 100, 2) AS late_delivery_rate_pct
FROM segment_performance
ORDER BY avg_days_late DESC;

--Q5.Identify the peak hours and days of the week for order volume. Analyze whether these periods of high demand 
--correlate with a spike in average delivery delays, indicating potential capacity issues in the warehouse or 
--shipping infrastructure.

WITH time_trends AS (
    SELECT 
        EXTRACT(DOW FROM order_date_dateorders) AS day_of_week, -- 0 (Sun) to 6 (Sat)
        EXTRACT(HOUR FROM order_date_dateorders) AS hour_of_day,
        COUNT(*) AS total_orders,
        AVG(delay_days) AS avg_delay
    FROM dataco_supply_chain
    GROUP BY day_of_week, hour_of_day
)

SELECT 
    CASE 
        WHEN day_of_week = 0 THEN 'Sunday'
        WHEN day_of_week = 1 THEN 'Monday'
        WHEN day_of_week = 2 THEN 'Tuesday'
        WHEN day_of_week = 3 THEN 'Wednesday'
        WHEN day_of_week = 4 THEN 'Thursday'
        WHEN day_of_week = 5 THEN 'Friday'
        WHEN day_of_week = 6 THEN 'Saturday'
    END AS weekday,
    hour_of_day,
    total_orders,
    ROUND(avg_delay::NUMERIC, 2) AS avg_delay_days
FROM time_trends
ORDER BY total_orders DESC 
LIMIT 15;
