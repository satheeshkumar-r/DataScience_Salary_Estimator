# [DataScience_Salary_Estimator](https://github.com/satheeshkumar-r/DataScience_Salary_Estimator)
The goal of this project is to build a model that predicts the average salary of a Data Scientist. The process consists of:
  *	Glassdoor scraping
  *	Data Cleaning
  *	Exploratory Data Analysis
  *	Model Building


## Glassdoor Scraping
Pulled out the current job postings from glassdoor.com available in 8 states throughout the United States. With each job, we get the following:
*	Job_Title, Company_Name,	City_State,	Company_Rating,	salary_Range, and	Post_Date

## Data Cleaning
It helps to remove inaccurate and unwanted data. 
*	Parsed salary_Range
*	Parsed City_State
*	Parsed Post_Date
*	Parsed Job_Title

## Exploratory Data Analysis
EDA depicts
*	Histogram View
*	Boxplot View
*	Correlation View
*	Heatmap View
*	Barplot View
*	Pivot table view

## Model Building
Considered three different models and evaluated them using root-mean-square error. Model performance evaluated as below.
*	**Multi-Linear Regression** : MAE = 23.93827
*	**Decision Tree Regression**: MAE = 24.14426
*	**Random Forest Regression**: MAE = 9.984035

The Random Forest model far outperformed the other approaches on the test and validation sets. 
