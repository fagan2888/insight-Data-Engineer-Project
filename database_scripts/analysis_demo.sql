/*shows the tables that are available in your database*/
SELECT
  DISTINCT tablename
FROM
  PG_TABLE_DEF
WHERE
  schemaname = 'public';

select * from loans_raw_fannie
limit 5;

select * from monthly_observations_raw_fannie
limit 5;

/* counts the loans originated each year*/
create table orig_by_year as
select count(*), date_part(to_date(origination_date, 'MM/YYYY')) as origination_date
from loans_raw_fannie
group by origination_date;

select origination_date from loans_raw_fannie limit 5;
select to_date(origination_date, 'MM/YYYY') as origination_date from loans_raw_fannie limit 5;
select date_part(year, to_date(origination_date, 'MM/YYYY')) as origination_date from loans_raw_fannie limit 5;

select distinct zero_balance_code from monthly_observations_raw_fannie;

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

select * from zb_loans limit 5;

select count (*) from zb_loans;
select count(*) from loans_raw_fannie;

/*this should give you an overview of all the loans with zero balance status*/
create table zb_loans_info as
select * from
  (select * from zb_loans)
  left join loans_raw_fannie
  using (loan_sequence_number);

select count(*) from zb_loans_info;
select * from zb_loans_info limit 5;

drop table zb_loans;

/* count the number of default over the years*/
create table default_loans_info as
select * from zb_loans_info
where zero_balance_code in ('09', '15','03');

select * from default_loans_info limit 5;

create table default_by_orgin_year as
select count(*) as default_count, to_date(origination_date, 'MM/YYYY') as origination_date
from default_loans_info
group by origination_year;

/*now put together the origination year and the default of that origination year*/
create table default_rate_by_origin_year as
select * from default_by_orgin_year
join orig_by_year
using(origination_year);

drop table default_by_orgin_year;
drop table orig_by_year;

/* default by vintage year */
create table monthly_observations_order_fannie as
select * from monthly_observations_raw_fannie
order by loan_sequence_number, reporting_period desc;


/* see the default rate by state */
create table count_by_state as
select count(*) as loan_count, property_state from loans_raw_fannie
group by property_state;

select * from count_by_state limit 5;

create table default_by_state as
select count(*) as default_count, property_state from default_loans_info
group by property_state;


select * from default_by_state limit 5;

create table default_rate_by_state as
select * from count_by_state
join default_by_state
using(property_state);

select * from default_rate_by_state limit 5;

drop table count_by_state, default_by_state;

select * from loans_raw_fannie limit 5;

/* comparision of default and healthy loan in terms of fico and DTI*/
create table credit_performance as
select loan_sequence_number, dti, original_ltv, FICO, first_time_homebuyer_indicator, zero_balance_code
from
(select loan_sequence_number, dti, original_ltv,
 case when credit_score > co_borrower_credit_score then co_borrower_credit_score
      else credit_score
      end as FICO,
      first_time_homebuyer_indicator
from loans_raw_fannie) left join
(select loan_sequence_number, zero_balance_code from zb_loans_info)
using(loan_sequence_number);

select count(*) from credit_performance;
select distinct zero_balance_code from credit_performance;


create table credit_performance_cat as
select * ,
case when zero_balance_code = '16' then 'Note Sell'
     when zero_balance_code = '09' then 'Default'
     when zero_balance_code = '03' then 'Short Sell'
     when zero_balance_code = '06' then 'Default'
     when zero_balance_code = '15' then 'Default'
     when zero_balance_code = '02' then 'Note Sell'
     when zero_balance_code = '01' then 'Prepay'
     else 'Current'
     end as status
from credit_performance;

select * from credit_performance_cat limit 5;

drop table credit_performance;

/* Sample a subset so it is plottable in tableau */
create table credit_performance_small as
select * from credit_performance_cat
order by random()
limit 10000;
