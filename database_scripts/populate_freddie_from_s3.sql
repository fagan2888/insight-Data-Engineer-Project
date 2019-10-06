/*this script populate your freddie tables from the textfile stored in your s3*/
copy loans_raw_fannie from 's3://fanniemaedata/historical_data1_Q'
credentials 'aws_access_key_id=<>;aws_secret_access_key=<>'
delimiter '|' region 'us-west-1';

copy monthly_observations_raw_fannie from 's3://fanniemaedata/historical_data1_time_Q'
credentials 'aws_access_key_id=<>;aws_secret_access_key=<>'
delimiter '|' region 'us-west-1'
DATEFORMAT AS 'YYYYMM';
