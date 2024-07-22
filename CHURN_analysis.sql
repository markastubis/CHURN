/* overview of the data to check for errors */
select * from public."Main";  
/* seeing how many customers have churned */
select "Churn", count(*) from public."Main" group by "Churn";


/* Consumer distributions */
/* Gender distribution */
select "Gender", count(*) from public."Main" group by "Gender" ;

/* Age distribution */
select "Age", count(*) from public."Main" group by "Age" ;

/* Counting churn consumers at certain age groups */
select "Age", count(*) from public."Main"  where "Churn" = 1 group by "Age";

select "Gender", count(*) from public."Main"  where "Churn" = 1 group by "Gender";
/* Tenure analysis */
/*What is the average tenure of customers who have churned versus those who have not? */
SELECT "Churn", AVG("Tenure") AS avg_tenure
FROM public."Main"
GROUP BY "Churn";

/* What is the churn rate for each contract type? */
/* First seeing how many people have what subscription types */

SELECT "Subscription Type", COUNT(*) AS total_users
FROM public."Main"
GROUP BY "Subscription Type" ;

/* Now calculating the churn ratio for each of the subscription types */
SELECT "Subscription Type",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS churn_rate
FROM public."Main"
GROUP BY "Subscription Type";
/* The distribution of consumers across all of the plans is quite simillar 
as well as the churn rate is almost the same so there is no reason to believe that 
a subscription plan plays a role in the churn */

/* Maybe price is an issue */
/*What is the average monthly charge for customers who churned compared to those who did not? */

SELECT "Churn", AVG("Total Spend") AS avg_total_spend
FROM public."Main"
GROUP BY "Churn";

/* We can see that churned consumers spend on average a lot less */

/*What is the churn rate for each average support call  frequency */

SELECT "Support Calls", 
       COUNT(*) AS total_customers, 
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churned_customers,
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS churn_rate
FROM public."Main"
GROUP BY "Support Calls";

/* As support calls increase churn rate increases significantly, even reaching 100%
This could be the primary objective to reducing churn ratio */

/*What is the churn rate for different levels of usage frequency?*/

SELECT "Usage Frequency", 
       COUNT(*) AS total_customers, 
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churned_customers,
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS churn_rate
FROM public."Main"
GROUP BY "Usage Frequency";

/* As expected as usage frequency increases the churn rate decreases. What concerns me
is the fact that even when usage frequency is 30( which is the maximum value) the churn rate 
is still above 50%. This, we should look more closely with targeted user surveys for example */

/*What is the churn rate for different tenure groups (e.g., 0-12 months, 13-24 months, etc.)?*/

SELECT CASE 
         WHEN "Tenure" BETWEEN 0 AND 12 THEN '0-12 months'
         WHEN "Tenure" BETWEEN 13 AND 24 THEN '13-24 months'
         WHEN "Tenure" BETWEEN 25 AND 36 THEN '25-36 months'
         ELSE '37+ months'
       END AS tenure_group,
       COUNT(*) AS total_customers, 
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churned_customers,
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS churn_rate
FROM public."Main"
GROUP BY tenure_group;

/*While we get mostly inline results (tenure increases, churn rate decreases) but we have
an outlier in the churn_rate, which is 13-24 months we investigate further*/

SELECT 
  CASE 
    WHEN "Tenure" BETWEEN 0 AND 12 THEN '0-12 months'
    WHEN "Tenure" BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN "Tenure" BETWEEN 25 AND 36 THEN '25-36 months'
    ELSE '37+ months'
  END AS tenure_group,
  AVG("Support Calls") AS avg_support_calls
FROM public."Main"
GROUP BY tenure_group;

/* Strangly, the 13-24 month tenure group support_calls the most which is probably leading 
to an increase in the churn ratio. */ 


SELECT "Payment Delay", 
       COUNT(*) AS total_customers, 
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) AS churned_customers,
       SUM(CASE WHEN "Churn" = 1 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS churn_rate
FROM public."Main"
GROUP BY "Payment Delay";

/* Churn rate remains simillar towards all of the payment delays (very similar total_customers
in each of the payment_delay section) until day 20, when the churn ratio become 100%, this 
could be caused by company policy */

SELECT 
    "Gender",
    AVG("Total Spend") AS avg_total_spend,
    AVG("Tenure") AS avg_tenure,
    AVG("Usage Frequency") AS avg_usage_frequency,
    AVG("Support Calls") AS avg_support_calls,
    AVG("Payment Delay") AS avg_payment_delay,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 0 THEN 1 ELSE 0 END) AS retained_customers,
    SUM(CASE WHEN "Churn" = 0 THEN 1 ELSE 0 END) / COUNT(*)::decimal * 100 AS retention_rate
FROM public."Main"
GROUP BY "Gender";

/* We can see that we retain a lot more men, who spend more, use it more, calls support less
and on average are late less. This, could imply we need to implement  targeted retention 
strategies for female customers, such as personalized offers, improved customer support,
and addressing any specific issues they face */

/* Conclusion, key thing to improve would be the support calls. Firstly, we would need to
understand why are people calling for support is it the fact that the service is breaking down
or the fact that it is too complicated to use. After we know this information we could move
further. We could also appoint independent "fake" callers, so we would know that our 
customer support is up to a companies expectations. Another thing we could do is dig deeper
for payment delays. Is our pricing strategy correct or whether we need to improve payment
methods and so on. Lastly, we need to imprement targeted retention for female customers
and find out the exact reasons on why their retention_rate is so small compared to males


