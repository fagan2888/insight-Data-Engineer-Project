# Instruction for using the download program

To download the entire data set manually takes a long time and would possibly flood your disk (The most updated fannie mac data set has about 250 GB raw text files).

When you use Othewise download program to download these files by year or by quarter. It downloads files one by one, unzip and upload to S3, then remove the zipfile to release more disk space.

Specify the begining and ending period you want to download by specify the beigin year/quarter and end year/quarter arguments. Othewise, the default setting will download all the files that are currently available.

For example, if you would like to download the loan level data from 2003 first quarter to 2004 last quarter, this is how you would specify your input:

```
python download.py -by 2003 -bq 1 -ey 2004 -eq 4
```
`by` stands for begin_year, `ey` stands for end_year, `bq` stands for begin_year, and `eq` stands for end_quarter.

If you would like to download all the available data, do not specify any arguments at all:

```
python download.py
```

In order to begin the downloading, edit your credential in the yaml file.
