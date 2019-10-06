"""
run this program to download all the single-family loan data by quarters or for a specific period
this program assume the user has a s3 bucket called fanniemaedata
edit the credentials file with your own account information
"""

import os
import zipfile
import argparse
import requests
import boto3
import credentials

data = {
    'username': username,
    'password': password
}

def download_fannie(file_name):
    """
    download the individual quarterly file
    """
    s = requests.Session()
    s.post('https://loanperformancedata.fanniemae.com/lppub/loginForm.html', data=data)
    file_url = 'https://loanperformancedata.fanniemae.com/lppub/publish_aws?file=' + file_name

    print ("Downloading", file_name)
    with open(file_name, 'wb') as file:
        file.write(s.get(file_url).content)
        file.close()

def unzip_fannie(file_name):
    """
    unzip the individual quarterly file
    """
    zip = zipfile.ZipFile(file_name)
    zip.extractall()
    zip_namelist = zipfile.ZipFile(file_name).namelist()
    return zip_namelist

def upload_fannie(file_name, zip_namelist):
    """
    Upload the unzipped txt files to s3 and remove the zip file in localhost
    """
    s3 = boto3.resource('s3')
    for txtfile_name in zip_namelist:
        s3.Object('fanniemaedata', txtfile_name).upload_file(txtfile_name)
        os.remove(txtfile_name)
    os.remove(file_name)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='run this program to download all the single-family loan data by quarters or for a specific period')
    parser.add_argument('-b', '--begin_year', help='the Beginning year')
    parser.add_argument('-e', '--end_year', help='the end year')
    parser.add_argument('-bq', '--begin_quarter', help='the begining quarter')
    parser.add_argument('-eq', '--end_quarter', help='the end quarter')
    args = parser.parse_args()

    begin_year = int(beg_data[0:4])
    begin_quarter = int(beg_data[-1])
    end_year = int(end_data[0:4])
    end_quarter = int(end_data[-1])

    if begin_year < end_year or (begin_year == end_year and begin_quarter <= end_quarter):
        for year in range(begin_year, end_year + 1):
            if year == begin_year:
                start = begin_quarter
                if year == end_year:
                    end = end_quarter
                else:
                    end = 4
            elif year == end_year:
                start = 1
                end = end_quarter
            else:
                start = 1
                end = 4
    else:
        print ("Beginning quarter given comes after ending quarter given.")

    # download all files if user has not specified a beigining period and a end period
    files = [str(x)+'Q'+str(y)+'.zip' for x in range(2000, 2019) for y in range(1, 5)]

    for file_name in files:
        download_fannie(file_name)
        zip_namelist = unzip_fannie(file_name)
        upload_fannie(file_name, zip_namelist)
