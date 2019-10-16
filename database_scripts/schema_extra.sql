/*This script contains schemas for potential queries you may want to try out*/
CREATE TABLE agencies
(
  id     INTEGER PRIMARY KEY,
  name   VARCHAR
);

INSERT INTO agencies
VALUES
(
  0,
  'Fannie Mae'
),
(
  1,
  'Freddie Mac'
);

CREATE TABLE servicers
(
  id     serial PRIMARY KEY,
  name   text
)
SORTKEY (name);

CREATE TABLE loans
(
  id                              serial PRIMARY KEY,
  agency_id                       INTEGER NOT NULL,
  credit_score                    INTEGER,
  first_payment_date              DATE,
  first_time_homebuyer_flag       text,
  maturity_date                   DATE,
  msa                             INTEGER,
  mip                             INTEGER,
  number_of_units                 INTEGER,
  occupancy_status                text,
  ocltv                           NUMERIC,
  dti                             INTEGER,
  original_upb                    NUMERIC,
  oltv                            NUMERIC,
  original_interest_rate          NUMERIC,
  channel                         text,
  prepayment_penalty_flag         text,
  product_type                    text,
  property_state                  text,
  property_type                   text,
  postal_code                     INTEGER,
  loan_sequence_number            text,
  loan_purpose                    text,
  original_loan_term              INTEGER,
  number_of_borrowers             INTEGER,
  seller_id                       INTEGER,
  servicer_id                     INTEGER,
  super_conforming_flag           text,
  pre_harp_loan_sequence_number   text,
  vintage                         INTEGER,
  hpi_index_id                    INTEGER,
  hpi_at_origination              NUMERIC,
  final_zero_balance_code         INTEGER,
  final_zero_balance_date         DATE,
  first_serious_dq_date           DATE,
  sato                            NUMERIC,
  co_borrower_credit_score        INTEGER,
  mortgage_insurance_type         INTEGER,
  relocation_mortgage_indicator   text
)
SORTKEY (loan_sequence_number);

CREATE TABLE monthly_observations
(
  loan_id                 INTEGER NOT NULL,
  DATE DATE NOT NULL,
  current_upb             NUMERIC,
  previous_upb            NUMERIC,
  dq_status               INTEGER,
  previous_dq_status      INTEGER,
  loan_age                INTEGER,
  rmm                     INTEGER,
  repurchase_flag         text,
  modification_flag       text,
  zero_balance_code       INTEGER,
  zero_balance_date       DATE,
  current_interest_rate   NUMERIC
);

CREATE TABLE zero_balance_monthly_observations
(
  loan_id                                  INTEGER NOT NULL,
  DATE DATE NOT NULL,
  zero_balance_code                        INTEGER,
  zero_balance_date                        DATE,
  last_paid_installment_date               DATE,
  mi_recoveries                            NUMERIC,
  net_sales_proceeds                       NUMERIC,
  non_mi_recoveries                        NUMERIC,
  expenses                                 NUMERIC,
  legal_costs                              NUMERIC,
  maintenance_costs                        NUMERIC,
  taxes_and_insurance                      NUMERIC,
  miscellaneous_expenses                   NUMERIC,
  actual_loss_calculation                  NUMERIC,
  modification_cost                        NUMERIC,
  foreclosure_date                         DATE,
  disposition_date                         DATE,
  foreclosure_costs                        NUMERIC,
  preservation_and_repair_costs            NUMERIC,
  asset_recovery_costs                     NUMERIC,
  associated_taxes                         NUMERIC,
  net_sale_proceeds                        NUMERIC,
  credit_enhancement_proceeds              NUMERIC,
  repurchase_make_whole_proceeds           NUMERIC,
  other_foreclosure_proceeds               NUMERIC,
  non_interest_bearing_upb                 NUMERIC,
  principal_forgiveness_upb                NUMERIC,
  repurchase_make_whole_proceeds_flag      text,
  foreclosure_principal_write_off_amount   NUMERIC,
  servicing_activity_indicator             text
);

CREATE VIEW loan_monthly
AS
SELECT l.*,
       m.loan_id,
       m.date,
       m.current_upb,
       m.previous_upb,
       m.dq_status,
       m.previous_dq_status,
       m.loan_age,
       m.rmm,
       m.repurchase_flag,
       m.modification_flag,
       m.current_interest_rate,
       m.zero_balance_code,
       COALESCE(m.current_upb,l.original_upb) AS current_weight,
       COALESCE(m.previous_upb,l.original_upb) AS previous_weight
FROM loans l
  INNER JOIN monthly_observations m ON l.id = m.loan_id;

CREATE TABLE mortgage_rates
(
  month                     DATE PRIMARY KEY,
  rate_30_year              NUMERIC,
  points_30_year            NUMERIC,
  zero_point_rate_30_year   NUMERIC,
  rate_15_year              NUMERIC,
  points_15_year            NUMERIC,
  zero_point_rate_15_year   NUMERIC
);

CREATE TABLE raw_msa_county_mappings
(
  cbsa_code            INTEGER,
  msad_code            INTEGER,
  csa_code             INTEGER,
  cbsa_name            VARCHAR,
  msa_type             VARCHAR,
  msad_name            VARCHAR,
  csa_name             VARCHAR,
  county               VARCHAR,
  state                VARCHAR,
  state_fips           INTEGER,
  county_fips          INTEGER,
  county_type          VARCHAR,
  state_abbreviation   VARCHAR
)
SORTKEY (cbsa_code,msad_code,state_fips,county_fips);
