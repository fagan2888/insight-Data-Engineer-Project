# Instruction to use the database scripts

These scripts build the database from the all the Freddie Mac and Fannie Mae data sets on your s3 and get you started on some of the cool queries you can realize now that you have all the pieces at your disposal.

Step 1: run the raw schema files. The raw schema files specify how all the columns should be read, compressed,  specify the sortkeys and distribution keys for the tables.

Step 2: run the populate files. The populate files will ingest the raw tables from all the raw text files we just uploaded to S3.

Step 3: qurey away! The analysis demo show you a couple of basic findings:

![Observe the 2008 Housing Crisis](../docs/default_by_origination_year.png)
* [Observe the 2008 Housing Crisis -- click to see the interactive graph](https://public.tableau.com/profile/liwen6329#!/vizhome/default_by_orig_year/Sheet2)<br/>
![Cumulative Default Rate by States](../docs/default_rate_by_state.png)
* [Cumulative Default Rate by States -- click to see the interactive graph](https://public.tableau.com/profile/liwen6329#!/vizhome/default_by_state/Sheet1)<br/>
![Watch out for the low FICO](../docs/fico_scores_vs_default_status.png)
* [Watch out for the low FICO -- click to see the interactive graph](https://public.tableau.com/profile/liwen6329#!/vizhome/FicoScoresvsDefaultStatus/Sheet1)<br/>
![First home buyers are your better bet](../docs/first_home_buyers_default_status.png)
* [First home buyers are your better bet -- click to see the interactive graph](https://public.tableau.com/profile/liwen6329#!/vizhome/FirstHomevsDefaultStatus/Sheet2)<br/>

Step 4: If you are up for exploring the mortgage markets. This is only an iceberg of what this data can show. Use the extra schema, and extra analysis scripts to generate more insight. Or fire up your own sql queries!
