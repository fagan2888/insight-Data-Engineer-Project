/*this script populate your fannie tables from the textfile stored in your s3*/
copy fannie_harp_mapping from 's3://fanniemaedata/Loan_Mapping.txt'
credentials 'aws_access_key_id=<>;aws_secret_access_key=<>'
delimiter ',' region 'us-west-1';


copy loans_raw_fannie from 's3://fanniemaedata/Acquisition'
credentials 'aws_access_key_id=<>;aws_secret_access_key=<>'
delimiter '|' region 'us-west-1';

copy monthly_observations_raw_fannie from 's3://fanniemaedata/Performance'
credentials 'aws_access_key_id=<>;aws_secret_access_key=<>'
delimiter '|' region 'us-west-1'
DATEFORMAT AS 'MM/DD/YYYY';
