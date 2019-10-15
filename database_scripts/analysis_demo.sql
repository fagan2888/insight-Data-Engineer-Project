/*shows the tables that are available in your database*/
SELECT DISTINCT tablename
FROM PG_TABLE_DEF
WHERE schemaname = 'public';



/* counts the loans originated each year*/
DROP TABLE IF EXISTS orig_by_year;
CREATE TABLE orig_by_year
AS
SELECT COUNT(*),
       date_part(to_date (origination_date,'MM/YYYY')) AS origination_date
FROM loans_raw_fannie
GROUP BY origination_date;


DROP TABLE IF EXISTS zb_loans;
CREATE TABLE zb_loans
AS
SELECT loan_sequence_number,
       reporting_period,
       current_interest_rate,
       current_upb,
       msa,
       dq_status,
       zero_balance_code,
       zero_balance_date
FROM monthly_observations_raw_fannie
WHERE zero_balance_code <> '';

/*this should give you an overview of all the loans with zero balance status*/
DROP TABLE IF EXISTS zb_loans_info;
CREATE TABLE zb_loans_info
AS
SELECT *
FROM (SELECT * FROM zb_loans)
  LEFT JOIN loans_raw_fannie USING (loan_sequence_number);

DROP TABLE zb_loans;

/* count the number of default over the years*/
DROP TABLE IF EXISTS default_loans_info;
CREATE TABLE default_loans_info
AS
SELECT *
FROM zb_loans_info
WHERE zero_balance_code IN ('09','15','03');

DROP TABLE IF EXISTS default_by_orgin_year;
CREATE TABLE default_by_orgin_year
AS
SELECT COUNT(*) AS default_count,
       to_date(origination_date,'MM/YYYY') AS origination_date
FROM default_loans_info
GROUP BY origination_year;

/*now put together the origination year and the default of that origination year*/
DROP TABLE IF EXISTS default_rate_by_origin_year;
CREATE TABLE default_rate_by_origin_year
AS
SELECT *
FROM default_by_orgin_year
  JOIN orig_by_year USING (origination_year);

DROP TABLE default_by_orgin_year;
DROP TABLE orig_by_year;

/* see the default rate by state */
DROP TABLE IF EXISTS count_by_state;
CREATE TABLE count_by_state
AS
SELECT COUNT(*) AS loan_count,
       property_state
FROM loans_raw_fannie
GROUP BY property_state;

DROP TABLE IF EXISTS default_by_state;
CREATE TABLE default_by_state
AS
SELECT COUNT(*) AS default_count,
       property_state
FROM default_loans_info
GROUP BY property_state;

DROP TABLE IF EXISTS default_rate_by_state;
CREATE TABLE default_rate_by_state
AS
SELECT *
FROM count_by_state
  JOIN default_by_state USING (property_state);

DROP TABLE count_by_state, default_by_state;

/* comparision of default and healthy loan in terms of fico and DTI*/
DROP TABLE IF EXISTS credit_performance;
CREATE TABLE credit_performance
AS
SELECT loan_sequence_number,
       dti,
       original_ltv,
       FICO,
       first_time_homebuyer_indicator,
       zero_balance_code
FROM (SELECT loan_sequence_number,
             dti,
             original_ltv,
             CASE
               WHEN credit_score > co_borrower_credit_score THEN co_borrower_credit_score
               ELSE credit_score
             END AS FICO,
             first_time_homebuyer_indicator
      FROM loans_raw_fannie)
  LEFT JOIN (SELECT loan_sequence_number,
                    zero_balance_code
             FROM zb_loans_info) USING (loan_sequence_number);

DROP TABLE IF EXISTS credit_performance_cat;
CREATE TABLE credit_performance_cat
AS
SELECT *,
       CASE
         WHEN zero_balance_code = '16' THEN 'Note Sell'
         WHEN zero_balance_code = '09' THEN 'Default'
         WHEN zero_balance_code = '03' THEN 'Short Sell'
         WHEN zero_balance_code = '06' THEN 'Default'
         WHEN zero_balance_code = '15' THEN 'Default'
         WHEN zero_balance_code = '02' THEN 'Note Sell'
         WHEN zero_balance_code = '01' THEN 'Prepay'
         ELSE 'Current'
       END AS status
FROM credit_performance;

DROP TABLE credit_performance;

/* Sample a subset so it is plottable in tableau */
DROP TABLE IF EXISTS credit_performance_small;
CREATE TABLE credit_performance_small 
AS
SELECT *
FROM credit_performance_cat
ORDER BY random() limit 10000;
