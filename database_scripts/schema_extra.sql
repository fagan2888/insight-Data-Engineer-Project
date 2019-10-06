/*This script contains schemas for potential queries you may want to try out*/
CREATE TABLE agencies (
  id integer primary key,
  name varchar
);

INSERT INTO agencies
VALUES (0, 'Fannie Mae'), (1, 'Freddie Mac');

CREATE TABLE servicers (
  id serial primary key,
  name text
)
SORTKEY(name);

CREATE TABLE loans (
  id serial primary key,
  agency_id integer not null,
  credit_score integer,
  first_payment_date date,
  first_time_homebuyer_flag text,
  maturity_date date,
  msa integer,
  mip integer,
  number_of_units integer,
  occupancy_status text,
  ocltv numeric,
  dti integer,
  original_upb numeric,
  oltv numeric,
  original_interest_rate numeric,
  channel text,
  prepayment_penalty_flag text,
  product_type text,
  property_state text,
  property_type text,
  postal_code integer,
  loan_sequence_number text,
  loan_purpose text,
  original_loan_term integer,
  number_of_borrowers integer,
  seller_id integer,
  servicer_id integer,
  super_conforming_flag text,
  pre_harp_loan_sequence_number text,
  vintage integer,
  hpi_index_id integer,
  hpi_at_origination numeric,
  final_zero_balance_code integer,
  final_zero_balance_date date,
  first_serious_dq_date date,
  sato numeric,
  co_borrower_credit_score integer,
  mortgage_insurance_type integer,
  relocation_mortgage_indicator text
)
SORTKEY(loan_sequence_number);


CREATE TABLE monthly_observations (
  loan_id integer not null,
  date date not null,
  current_upb numeric,
  previous_upb numeric,
  dq_status integer,
  previous_dq_status integer,
  loan_age integer,
  rmm integer,
  repurchase_flag text,
  modification_flag text,
  zero_balance_code integer,
  zero_balance_date date,
  current_interest_rate numeric
);

CREATE TABLE zero_balance_monthly_observations (
  loan_id integer not null,
  date date not null,
  zero_balance_code integer,
  zero_balance_date date,
  last_paid_installment_date date,
  mi_recoveries numeric,
  net_sales_proceeds numeric,
  non_mi_recoveries numeric,
  expenses numeric,
  legal_costs numeric,
  maintenance_costs numeric,
  taxes_and_insurance numeric,
  miscellaneous_expenses numeric,
  actual_loss_calculation numeric,
  modification_cost numeric,
  foreclosure_date date,
  disposition_date date,
  foreclosure_costs numeric,
  preservation_and_repair_costs numeric,
  asset_recovery_costs numeric,
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

CREATE VIEW loan_monthly AS
SELECT
  l.*,
  m.loan_id, m.date, m.current_upb, m.previous_upb, m.dq_status, m.previous_dq_status,
  m.loan_age, m.rmm, m.repurchase_flag, m.modification_flag, m.current_interest_rate, m.zero_balance_code,
  COALESCE(m.current_upb, l.original_upb) AS current_weight,
  COALESCE(m.previous_upb, l.original_upb) AS previous_weight
FROM loans l
  INNER JOIN monthly_observations m
    ON l.id = m.loan_id;

CREATE TABLE mortgage_rates (
  month date primary key,
  rate_30_year numeric,
  points_30_year numeric,
  zero_point_rate_30_year numeric,
  rate_15_year numeric,
  points_15_year numeric,
  zero_point_rate_15_year numeric
);

CREATE TABLE raw_msa_county_mappings (
  cbsa_code integer,
  msad_code integer,
  csa_code integer,
  cbsa_name varchar,
  msa_type varchar,
  msad_name varchar,
  csa_name varchar,
  county varchar,
  state varchar,
  state_fips integer,
  county_fips integer,
  county_type varchar,
  state_abbreviation varchar
)
SORTKEY(cbsa_code, msad_code, state_fips, county_fips);
