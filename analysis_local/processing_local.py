import argparse
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os


# import the acquisition file and performance file
def import(Acquisition_data_path, Performance_data_path, Harp_Acquisition_path, Harp_Performance_path):
    Acquisition_col = [
        "LOAN_ID", "ORIG_CHN", "Seller.Name", "ORIG_RT", "ORIG_AMT", "ORIG_TRM", "ORIG_DTE","FRST_DTE", "OLTV",
        "OCLTV", "NUM_BO", "DTI", "CSCORE_B", "FTHB_FLG", "PURPOSE", "PROP_TYP","NUM_UNIT", "OCC_STAT", "STATE",
        "ZIP_3", "MI_PCT", "Product.Type", "CSCORE_C", "MI_TYPE", "RELOCATION_FLG"
        ]

    Acquisition_dtypes = [
        str, str, str, np.float64, np.float64, np.int64, str, str, np.float64,
        np.float64, str, np.float64, np.float64, str, str, str, str, str,
        str, str, np.float64, str, np.float64, np.float64, str
        ]

    Performance_col = [
        "LOAN_ID", "Monthly.Rpt.Prd", "Servicer.Name", "LAST_RT", "LAST_UPB", "Loan.Age", "Months.To.Legal.Mat",
        "Adj.Month.To.Mat", "Maturity.Date", "MSA", "Delq.Status", "MOD_FLAG", "Zero.Bal.Code",
        "ZB_DTE", "LPI_DTE", "FCC_DTE","DISP_DT", "FCC_COST", "PP_COST", "AR_COST", "IE_COST", "TAX_COST", "NS_PROCS",
        "CE_PROCS", "RMW_PROCS", "O_PROCS", "NON_INT_UPB", "PRIN_FORG_UPB_FHFA", "REPCH_FLAG", "PRIN_FORG_UPB_OTH", "TRANSFER_FLAG"
        ]

    Performance_dtypes = [
        str, str, str, np.float64, np.float64, np.float64, np.float64, np.float64, str,
        str, str, str, str, str, str, str, str, np.float64, np.float64, np.float64,
        np.float64, np.float64, np.float64, np.float64, np.float64, np.float64, np.float64,
        np.float64, str, np.float64, str
        ]

#import data
    acq = pd.read_csv(Acquisition_data_path, sep = '|', names = Acquisition_col,
                 dtype=dict(zip(Acquisition_col, Acquisition_dtypes )),
                 usecols=["LOAN_ID","ORIG_RT","ORIG_AMT","ORIG_DTE","OLTV","DTI","CSCORE_B","FTHB_FLG","CSCORE_C"])

    per = pd.read_csv(Performance_data_path, sep = '|', names = Performance_col,
                 dtype=dict(zip(Performance_col, Performance_dtypes)),
                 usecols=["LOAN_ID","Monthly.Rpt.Prd","Delq.Status","LAST_RT","LAST_UPB","Maturity.Date","Zero.Bal.Code",
                 "ZB_DTE", "LPI_DTE", "FCC_DTE","DISP_DT"])

    acq.sort_values(by = ['LOAN_ID'], inplace = True)
    per.sort_values(by = ['LOAN_ID'], inplace = True)

# import harp data
    Harp_Acquisition_col = ['H_'+ acq for acq in Acquisition_col]
    Harp_acq = pd.read_csv(Harp_Acquisition_path, sep = '|', names = Harp_Acquisition_col,
                     dtype=dict(zip(Harp_Acquisition_col, Acquisition_dtypes )),
                     usecols=["H_LOAN_ID","H_ORIG_RT","H_ORIG_AMT","H_ORIG_DTE","H_OLTV","H_DTI","H_CSCORE_B","H_FTHB_FLG","H_CSCORE_C"])

    ID_map = pd.read_csv("./HARP_Files/Loan_Mapping.txt", sep = ',', names = ["LOAN_ID", "H_LOAN_ID"],
                     dtype=str)


def data_merge(Harp_acq, Harp_per, acq, per):
    Harp_acq.sort_values(by = ['H_LOAN_ID'], inplace = True)

    Harp_acq = pd.merge(Harp_acq, ID_map, on="H_LOAN_ID", how = "left")

    Harp_Performance_col = ["H_LOAN_ID"] + Performance_col[1:]

    Harp_per = pd.read_csv(Harp_Performance_path , sep = '|', names = Harp_Performance_col,
                     dtype=dict(zip(Harp_Performance_col, Performance_dtypes)),
                     usecols=["H_LOAN_ID","Monthly.Rpt.Prd","Delq.Status","LAST_RT","LAST_UPB","Maturity.Date","Zero.Bal.Code",
                         "ZB_DTE", "LPI_DTE", "FCC_DTE","DISP_DT"])

    Harp_per.sort_values(by = ['H_LOAN_ID'], inplace = True)

    acq= pd.merge(acq, ID_map, on = 'LOAN_ID', how = 'left')
    acq_t = pd.merge(acq, Harp_acq, on = 'H_LOAN_ID', how ='left')

    acq_t['CSCORE_MIN'] = acq_t[['CSCORE_B','CSCORE_C']].min(axis=1)
    acq_t['ORIG_VAL']=round((acq_t['ORIG_AMT']/acq_t['OLTV'])*100, 1)

    Harp_per = pd.merge(Harp_per, ID_map, on ='H_LOAN_ID', how = 'left')

    per_id = per['LOAN_ID'].unique()

    Harp_sub = Harp_per.loc[Harp_per['LOAN_ID'].isin(per_id)]
    per = per.append(Harp_sub, sort=True)

    per['Monthly.Rpt.Prd'] = pd.to_datetime(per['Monthly.Rpt.Prd'])
    per.sort_values(by=["LOAN_ID", "Monthly.Rpt.Prd"], inplace = True)

    per['LAST_UPB'] = per.groupby('LOAN_ID')['LAST_UPB'].ffill()

    del Harp_per

# data processing
def classify_status():
    di = {'X':'999'}
    per = per.replace({'Delq.Status':di})

    per['Delq.Status'] = per['Delq.Status'].astype(float)

    per['FLAG_180'] = (per['Delq.Status'] == 6).astype(int)

    per['DTE_180'] = per.loc[per['FLAG_180']==1, 'Monthly.Rpt.Prd']

    per_last = per.groupby('LOAN_ID').last()

    acq_t['LOAN_ID'] = acq_t['LOAN_ID_x']
    acq_t.drop(columns = ['LOAN_ID_x', 'LOAN_ID_y'], inplace = True)

    final_data = pd.merge(acq_t, per_last, on = 'LOAN_ID')

    ZB_map = {'01':'P', '09':'F', '03':'S', '06':'R'}

    final_data['LAST_STAT'] = final_data['Zero.Bal.Code'].map(ZB_map)
    final_data['LAST_DELIQ'] = final_data['Delq.Status'].astype(str)
    final_data.loc[(final_data['Delq.Status']>8) & (final_data['Delq.Status']<999), 'LAST_DELIQ'] = 'DELIQ>9'
    final_data['LAST_STAT'].fillna(final_data['LAST_DELIQ'], inplace = True)
    final_data.loc[final_data['LAST_STAT']=='0.0', 'LAST_STAT'] = 'C'
    final_data['H_LOAN_ID'] = final_data['H_LOAN_ID_x']
    final_data.drop(columns = ['H_LOAN_ID_y', 'H_LOAN_ID_x'], inplace = True)

    final_data.to_csv('report.csv')

# plots
def plot_status_count(report):
    plt.figure(figsize = (12, 9))
    sns.barplot(y=report["LAST_STAT"].value_counts().index, x=report["LAST_STAT"].value_counts())
    plt.savefig('Status barplot')

def plot_credit_status(report):
    plt.figure(figsize = (12, 9))
    sns.boxplot(x="LAST_STAT", y="CSCORE_MIN", data=report,
           order=['P','C','1.0', '2.0', '3.0', '4.0','5.0', '6.0','7.0','8.0','DELIQ>9','S','F','R','999.0'])

    plt.savefig('CreditScores VS Status')

def plot_dti(report):
    plt.figure(figsize = (12, 9))
    sns.boxplot(x="LAST_STAT", y="DTI", data=report,
           order=['P','C','1.0', '2.0', '3.0', '4.0','5.0', '6.0','7.0','8.0','DELIQ>9','S','F','R','999.0'])

    plt.savefig('Status VS DTI')


if __name__ == '__main__':
    #specify the path for the input files
    parser = argparse.ArgumentParser(description='a program that process the four input files to perform the data manipulation and consolidation')
    parser.add_argument('-a', '--acquisition', help='Acquisition_data_path', required=True)
    parser.add_argument('-p', '--performance', help='Performance_data_path', required=True)
    parser.add_argument('-i', '--h_acquisition', help='Harp_Acquisition_path', required=True)
    parser.add_argument('-u', '--h_performance', help='Harp_Performance_path', required=True)
    args = parser.parse_args()
    #
    Acquisition_data_path = args.acquisition
    Performance_data_path = args.performance
    Harp_Acquisition_path = args.h_acquisition
    Harp_Performance_path = args.h_performance

    #execute
    import(Acquisition_data_path, Performance_data_path, Harp_Acquisition_path, Harp_Performance_path)
    data_merge(Harp_acq, Harp_per, acq, per)
    classify_status()
    plot_status_count(final_datafinal_data)
    plot_credit_status(final_data)
    plot_dti(final_data)
