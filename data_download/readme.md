# Instruction for using the download program

To download the entire data set manually takes a long time and would possibly flood your locale or remote machine if you don't have enough disk space(The most updated fannie mac data set has about 250 GB raw text files).

Use the download program to download these files by year or by quarter. It downloads these file one by one, unzip and upload to S3, then remove the zipfile to release more disk space.

Specify the begining and ending period you want to download by specify the beigin year/quarter and end year/quarter arguments. Othewise, the default setting will download all the files that are currently available.

In order to begin the downloading, edit your credential in the yaml file.
