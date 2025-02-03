# Module 2 Homework: Workflow Orchestration

## 1. Within the execution for ```Yellow``` Taxi data for the year ```2020``` and month ```12```: what is the uncompressed file size (i.e. the output file ```yellow_tripdata_2020-12.csv``` of the ```extract``` task)?

### **Answer**

In kestra, run the flow ```02_postgres_taxi.yaml``` with the inputs ```taxi: "yellow"```, ```year: "2020"``` and, ```month: 12```. After the ```extract``` task finish, pause the flow, look in the ```output``` tab, under the ```extract``` task, the ```outputFiles``` in Outputs tab and, select the ```yellow_tripdata_2020_12.csv``` file. The file size is **128.3 MB**.

## 2. What is the rendered value of the variable ```file``` when the inputs ```taxi``` is set to ```green```, ```year``` is set to ```2020```, and ```month``` is set to ```04``` during execution?

### **Answer**

For the ```02_postgres_taxi.yaml``` flow, the ```file``` variable has the following definition: ```"{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv"```. So for april 2020 green taxi input data, the ```file``` variable value is:   ```green_tripdata_2020-04.csv```

## 3. How many rows are there for the ```Yellow``` Taxi data for all CSV files in the year 2020?

### **Answer**

For every flow for ```Yellow``` Taxi data in the year 2020, the corresponding ```yellow_copy_in_to_staging_table``` ``` rows``` value in the Kestra ```metrics``` tab, are:

|month|rows|
|---|---|
|01|6,405,008|
|02|6,299,354|
|03|3,007,292|
|04|237,993|
|05|348,371|
|06|549,760|
|07|800,412|
|08|1,007,284|
|09|1,341,012|
|10|1,681,131|
|11|1,508,985|
|12|1,461,897|
|**TOTAL**|**24,648,499**|

## 4. How many rows are there for the ```Green``` Taxi data for all CSV files in the year 2020?

### **Answer**

For every flow for ```Green``` Taxi data in the year 2020, the corresponding ```green_copy_in_to_staging_table``` ``` rows``` value in the Kestra ```metrics``` tab, are:

|month|rows|
|---|---|
|01|447,770|
|02|398,632|
|03|223,406|
|04|35,612|
|05|57,360|
|06|63,109|
|07|72,257|
|08|81,063|
|09|87,987|
|10|95,120|
|11|88,605|
|12|83,130|
|**TOTAL**|**1,734,051**|

## 5. How many rows are there for the ```Yellow``` Taxi data for the March 2021 CSV file?

In this case, first modify the ```02_postgres_taxi.yaml```, add the ```"2021"``` ```value``` for the ```year``` input. After that, run this flow for ```Yellow``` Taxi for ```march``` of the year ```2021```. For this flow, the corresponding ```yellow_copy_in_to_staging_table``` ``` rows``` value in the Kestra ```metrics``` tab, are:

|rows|
|---|
|1,925,152|

## 6. How would you configure the timezone to New York in a Schedule trigger?

### **Answer**

For configure the timezone to New York in a Schedule trigger, add a ```timezone``` property set to ```America/New_York``` in the Schedule trigger configuration. Example:

```
timezone: "America/New_York"
```