"""
run this program to download all the single-family loan data by quarters
this program assume the user has a s3 bucket called fanniemaedata
edit the credentials file with your own account information
"""

import os
import zipfile
import requests
import credentials
import boto3

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
    files = [str(x)+'Q'+str(y)+'.zip' for x in range(2000, 2019) for y in range(1, 5)]
    for file_name in files:
        download_fannie(file_name)
        zip_namelist = unzip_fannie(file_name)
        upload_fannie(file_name, zip_namelist)
