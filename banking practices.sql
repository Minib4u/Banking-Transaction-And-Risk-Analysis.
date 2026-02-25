use banking_job;

select * from accounts;
select *  from transactionss;

select COALESCE(amount, 0) as amt
from transactionss;

# how to find duplicate records in the table
select customer_id, count(*)
from transactionss
group by customer_id
having count(*) >1;

# 1. Data Extraction & Joins
select c.customer_id, t.transaction_date, t.amount
from customers as c
left join transactionss as t
on c.customer_id =t.customer_id;

#2nd highest transaction amt

select max(amount) as highest_amount
from transactionss
where amount<(select max(amount) from transactionss);


       
# To avoid repeating logic
WITH active_customers AS (
    SELECT DISTINCT customer_id
    FROM transactionss
    WHERE transaction_date >= CURRENT_DATE - INTERVAL 31 DAY
)
SELECT *
FROM active_customers;       
       
# churn customer
SELECT MAX(Transaction_Date) AS Last_Transaction_Date
FROM Transactionss;

select customer_id
from customers
where last_transaction_date < date_sub(curdate(),interval 90 day);
  
       #suspicious transactions 
SELECT *
FROM transactionss
WHERE amount > 100000;

#find is regular/high value we can use with and case function
WITH total_spend AS (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM transactionss
    GROUP BY customer_id
)
SELECT
    customer_id,
    CASE
        WHEN total_amount > 100000 THEN 'HIGH VALUE'
        ELSE 'REGULAR'
    END AS customer_type
FROM total_spend;


       
# higest transaction
select customer_id, sum(amount) as total_amount
from transactionss
group by customer_id
order by total_amount desc
limit 1;

#number of transaction per customer
select customer_id, count(transaction_id) as total_transactions
from transactionss
group by customer_id;

#2. Transaction Volume & Trends
select date_format(transaction_date,'%y-%m') as month, count(*) as trn_count
from transactionss
where year(transaction_date)='2025'
group by 1
order by 1;

SELECT 
    account_id,
    transaction_date,
    SUM(
        CASE 
            WHEN transaction_type = 'CREDIT' THEN amount
            ELSE -amount
        END
    ) OVER (
        PARTITION BY account_id 
        ORDER BY transaction_date
    ) AS daily_balance
FROM transactionss;

# fraud customer
select distinct customer_id 
from transactionss
where is_suspicious=1;

# product wise revenue 
SELECT transaction_type,
       SUM(Amount) AS Product_Revenue
FROM Transactionss
GROUP BY transaction_type;

# transaction type
select customer_id, transaction_id, amount,
case
when amount>0 then 'credit'
when amount<0 then 'debit'
else 'zero'
end as transaction_type 
from transactionss;

# count number of transaction type
select transaction_type, count(*) as total_transaction
from transactionss
group by transaction_type;



