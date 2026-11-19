/*
Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend

=============================================================================================================================
*/

/*  
1) Base Query: Retrieving core columns from tables

---------------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW gold.report_customers AS 

WITH Base_Query AS (
---1) Base Query: Retrieving core columns from tables----
SELECT 
      S.order_number,
      S.product_key,
      S.order_date,
      S.sales_amount,
      S.quantity,
      C.customer_key,
      C.customer_number,
      CONCAT(C.first_name, ' ', C.last_name) AS customer_name,
      DATEDIFF(YEAR,birthdate,GETDATE()) AS age
FROM gold.fact_sales S 
LEFT JOIN gold.dim_customers C 
ON C.customer_key = S.customer_key 
WHERE order_date IS NOT NULL
) 


,customer_aggregation AS (

/*

2) Customer Aggregations:Summarizes key metrics at the customer level 
----------------------------------------------------------------------------------------------------------*/

SELECT 
     customer_key,
     customer_number,
     customer_name,
     age,
     COUNT(DISTINCT order_number) AS Total_Orders,
     SUM(sales_amount) AS Total_Sales,
     SUM(quantity) AS Total_Quantity_Purchased,
     COUNT(DISTINCT product_key) AS Total_Products,
     MAX(order_date) AS Last_OrderDate,
     DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM Base_Query
GROUP BY  customer_key,
          customer_number,
          customer_name,
          age
)

SELECT  
          customer_key,
          customer_number,
          customer_name,
          age,
          CASE WHEN age < 20 THEN 'Under 20'
               WHEN age BETWEEN 20 AND 29 THEN '20-29'
               WHEN age BETWEEN 30 AND 39 THEN '30-39'
               WHEN age BETWEEN 40 AND 49 THEN '40-49'
               ELSE '50 and above'
          END AS age_group, 
          CASE 
              WHEN lifespan >= 12 AND Total_Sales > 5000 THEN 'VIP'
              WHEN lifespan >= 12 AND Total_Sales <= 5000 THEN 'Regular'
              ELSE 'NEW'
          END AS customer_segment,
          Total_Orders,
          Total_Sales,
          Total_Quantity_Purchased,
          Total_Products,
          Last_OrderDate,
          DATEDIFF(MONTH,Last_OrderDate,GETDATE()) AS recency ,
          lifespan,
          ----Compute average order value(AVO) 
          CASE WHEN total_sales = 0 THEN 0 
          ELSE total_sales / total_orders 
          END AS avg_order_value,
          ----Compute average monthly spend----
          CASE WHEN lifespan = 0 THEN total_sales 
               ELSE total_sales /lifespan 
          END  AS Avg_monthly_spend
FROM customer_aggregation
