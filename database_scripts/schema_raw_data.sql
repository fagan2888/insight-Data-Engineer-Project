
/*This is the table schema for the fannie and freddie raw data input*/
CREATE TABLE loans_raw_freddie (
  credit_score text,
  first_payment_date integer,
  first_time_homebuyer_flag text,
  maturity_date integer,
  msa integer,
  mip text,
  number_of_units integer,
  occupancy_status text,
  ocltv numeric,
  dti text,
  original_upb numeric,
  oltv integer,
  original_interest_rate numeric,
  channel text,
  prepayment_penalty_flag text,
  product_type text,
  property_state text,
  property_type text,
  postal_code text,
  loan_id text,
  loan_purpose text,
  original_loan_term integer,
  number_of_borrowers integer,
  seller_name text,
  servicer_name text,
  super_conforming_flag text,
  loan_id text
);

CREATE TABLE monthly_observations_raw_freddie (
  loan_id text,
  reporting_period date,
  current_upb numeric,
  dq_status text,
  loan_age integer,
  rmm integer,
  repurchase_flag text,
  modification_flag text,
  zero_balance_code text,
  zero_balance_effective_date integer,
  current_interest_rate numeric,
  current_deferred_upb numeric,
  ddlpi integer,
  mi_recoveries numeric,
  net_sales_proceeds text,
  non_mi_recoveries numeric,
  expenses numeric,
  legal_costs numeric,
  maintenance_costs numeric,
  taxes_and_insurance numeric,
  miscellaneous_expenses numeric,
  actual_loss_calculation numeric,
  modification_cost numeric
);

CREATE TABLE loans_raw_fannie (
  loan_id text,
  channel text,
  seller_name text,
  original_interest_rate numeric,
  original_upb numeric,
  original_loan_term integer,
  origination_date text,
  first_payment_date text,
  original_ltv numeric,
  original_cltv numeric,
  number_of_borrowers integer,
  dti numeric,
  credit_score integer,
  first_time_homebuyer_indicator text,
  loan_purpose text,
  property_type text,
  number_of_units text,
  occupancy_status text,
  property_state text,
  zip_code text,
  mip numeric,
  product_type text,
  co_borrower_credit_score integer,
  mortgage_insurance_type integer,
  relocation_mortgage_indicator text
);


CREATE TABLE fannie_harp_mapping (
  loan_id text primary key,
  harp_loan_id text
);
CREATE UNIQUE INDEX index_fannie_harp ON fannie_harp_mapping (post_harp_loan_id);


CREATE TABLE monthly_observations_raw_fannie (
  loan_id text,
  reporting_period date,
  servicer_name text,
  current_interest_rate numeric,
  current_upb numeric,
  loan_age integer,
  rmm integer,
  adjusted_rmm integer,
  maturity_date text,
  msa integer,
  dq_status text,
  modification_flag text,
  zero_balance_code text,
  zero_balance_date text,
  last_paid_installment_date date,
  foreclosure_date date,
  disposition_date date,
  foreclosure_costs numeric,
  preservation_and_repair_costs numeric,
  asset_recovery_costs numeric,
  miscellaneous_expenses numeric,
  associated_taxes numeric,
  net_sale_proceeds numeric,
  credit_enhancement_proceeds numeric,
  repurchase_make_whole_proceeds numeric,
  other_foreclosure_proceeds numeric,
  non_interest_bearing_upb numeric,
  principal_forgiveness_upb numeric,
  repurchase_make_whole_proceeds_flag text,
  foreclosure_principal_write_off_amount numeric,
  servicing_activity_indicator text
);