CREATE TABLE loans_raw_freddie
(
  credit_score                    text encode bytedict,
  first_payment_date              INTEGER encode zstd,
  first_time_homebuyer_flag       text encode zstd,
  maturity_date                   INTEGER encode zstd,
  msa                             INTEGER encode zstd,
  mip                             text encode zstd,
  number_of_units                 INTEGER encode zstd,
  occupancy_status                text encode zstd,
  ocltv                           NUMERIC encode zstd,
  dti                             text encode zstd,
  original_upb                    NUMERIC encode zstd,
  oltv                            INTEGER encode zstd,
  original_interest_rate          NUMERIC encode zstd,
  channel                         text encode zstd,
  prepayment_penalty_flag         text encode zstd,
  product_type                    text encode zstd,
  property_state                  text encode zstd,
  property_type                   text encode zstd,
  postal_code                     text encode zstd,
  loan_sequence_number            text encode zstd,
  loan_purpose                    text encode zstd,
  original_loan_term              INTEGER encode zstd,
  number_of_borrowers             INTEGER encode zstd,
  seller_name                     text encode zstd,
  servicer_name                   text encode zstd,
  super_conforming_flag           text encode zstd,
  pre_harp_loan_sequence_number   text encode zstd
)
DISTKEY(pre_harp_loan_sequence_number)
SORTKEY(first_payment_date, pre_harp_loan_sequence_number);

CREATE TABLE monthly_observations_raw_freddie
(
  loan_sequence_number          text encode zstd,
  reporting_period              DATE,
  current_upb                   NUMERIC encode zstd,
  dq_status                     text encode zstd,
  loan_age                      INTEGER encode zstd,
  rmm                           INTEGER encode zstd ,
  repurchase_flag               text encode zstd,
  modification_flag             text encode zstd,
  zero_balance_code             text encode zstd,
  zero_balance_effective_date   INTEGER encode zstd,
  current_interest_rate         NUMERIC encode zstd,
  current_deferred_upb          NUMERIC encode zstd,
  ddlpi                         INTEGER encode zstd,
  mi_recoveries                 NUMERIC encode zstd,
  net_sales_proceeds            text encode lzo,
  non_mi_recoveries             NUMERIC encode zstd,
  expenses                      NUMERIC encode zstd,
  legal_costs                   NUMERIC encode zstd,
  maintenance_costs             NUMERIC encode zstd,
  taxes_and_insurance           NUMERIC encode zstd,
  miscellaneous_expenses        NUMERIC encode zstd,
  actual_loss_calculation       NUMERIC encode zstd,
  modification_cost             NUMERIC encode zstd
)
DISTKEY(loan_sequence_number)
SORTKEY(reporting_period, loan_sequence_number);

CREATE TABLE loans_raw_fannie
(
  loan_sequence_number             text encode zstd,
  channel                          text encode zstd,
  seller_name                      text encode zstd,
  original_interest_rate           NUMERIC encode zstd,
  original_upb                     NUMERIC encode zstd,
  original_loan_term               INTEGER encode zstd,
  origination_date                 text,
  first_payment_date               text encode zstd,
  original_ltv                     NUMERIC encode zstd,
  original_cltv                    NUMERIC encode zstd,
  number_of_borrowers              INTEGER encode zstd,
  dti                              NUMERIC encode zstd,
  credit_score                     INTEGER encode bytedict,
  first_time_homebuyer_indicator   text encode zstd,
  loan_purpose                     text encode zstd,
  property_type                    text encode zstd,
  number_of_units                  text encode zstd,
  occupancy_status                 text encode zstd,
  property_state                   text encode zstd,
  zip_code                         text encode zstd,
  mip                              NUMERIC encode zstd,
  product_type                     text encode zstd,
  co_borrower_credit_score         INTEGER encode bytedict,
  mortgage_insurance_type          INTEGER encode zstd,
  relocation_mortgage_indicator    text encode zstd
)
DISTKEY(loan_sequence_number)
SORTKEY(origination_date, loan_sequence_number);

CREATE TABLE fannie_harp_mapping
(
  pre_harp_loan_sequence_number    text PRIMARY KEY,
  post_harp_loan_sequence_number   text
)
DISTKEY(pre_harp_loan_sequence_number)
SORTKEY(pre_harp_loan_sequence_number, pre_harp_loan_sequence_number);

CREATE TABLE monthly_observations_raw_fannie
(
  loan_sequence_number                     text encode zstd,
  reporting_period                         DATE,
  servicer_name                            text encode zstd,
  current_interest_rate                    NUMERIC encode zstd,
  current_upb                              NUMERIC encode zstd,
  loan_age                                 INTEGER encode zstd,
  rmm                                      INTEGER encode zstd,
  adjusted_rmm                             INTEGER encode zstd,
  maturity_date                            text encode zstd,
  msa                                      INTEGER encode zstd,
  dq_status                                text encode zstd,
  modification_flag                        text encode zstd,
  zero_balance_code                        text encode zstd,
  zero_balance_date                        text encode zstd,
  last_paid_installment_date               DATE encode zstd,
  foreclosure_date                         DATE encode zstd,
  disposition_date                         DATE encode zstd,
  foreclosure_costs                        NUMERIC encode zstd,
  preservation_and_repair_costs            NUMERIC encode zstd,
  asset_recovery_costs                     NUMERIC encode zstd,
  miscellaneous_expenses                   NUMERIC encode zstd,
  associated_taxes                         NUMERIC encode zstd,
  net_sale_proceeds                        NUMERIC encode zstd,
  credit_enhancement_proceeds              NUMERIC encode zstd,
  repurchase_make_whole_proceeds           NUMERIC encode lzo,
  other_foreclosure_proceeds               NUMERIC encode zstd,
  non_interest_bearing_upb                 NUMERIC encode zstd,
  principal_forgiveness_upb                NUMERIC encode zstd,
  repurchase_make_whole_proceeds_flag      text encode zstd,
  foreclosure_principal_write_off_amount   NUMERIC encode zstd,
  servicing_activity_indicator             text encode zstd
)
DISTKEY(loan_sequence_number)
SORTKEY(reporting_period,loan_sequence_number);
