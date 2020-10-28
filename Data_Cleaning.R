
# install.packages('sjmisc')   # Collection of miscellaneous utility functions, supporting datatransformation tasks like recoding, dichotomizing or grouping variables,setting and replacing missing values. The data transformation functionsalso support labelled data, and all integrate seamlessly into a'tidyverse'-workflow.
# install.packages('stringr')   

library(sjmisc)
library(stringr)

getwd()
setwd('E:/Data Science/01. Projects/03. DataScience_Salary_Estimator')

df = read.csv('Glassdoor_JobData.csv')

#head(df)

### Salary Parsing

df$hourly = lapply(df$salary_Range, function(x){ifelse(str_contains(x,'per hour',ignore.case = TRUE) == TRUE, 1, 0 )}) 
# nrow(df[df$hourly == 1, ])             

df = df[is.na(df$salary_Range) != TRUE, ]
# nrow(df)

salary = str_split_fixed(df$salary_Range, '[(]', 2)[,1]
salary = str_replace_all(c(salary),'Per Hour','')
salary = str_replace_all(salary, '[$]', '')
salary = str_replace_all(salary, 'K','')
salary =  str_trim(salary)

df$min_salary = str_split_fixed(salary, '[-]', 2)[,1]
df$max_salary = str_split_fixed(salary, '[-]', 2)[,2]

df$min_salary = as.numeric(df$min_salary)
df$max_salary = as.numeric(df$max_salary)
df$avg_salary = apply(df[,8:9], 1, mean) 

### Location Parsing
df$job_state = str_trim(str_split_fixed(df$City_State, ',', 2)[,2])
table(df$job_state)

### Title Parsing    
Title_Simplifier = function(x)
{
  if      (str_contains(x,'data scientist', ignore.case = TRUE) == TRUE) { return ('data scientist')}
  else if (str_contains(x,'data engineer', ignore.case = TRUE) == TRUE) { return ('data engineer')}
  else if (str_contains(x,'analyst', ignore.case = TRUE) == TRUE) { return ('analyst')}
  else if (str_contains(x,'machine learning', ignore.case = TRUE) == TRUE) { return ('mle')}
  else if (str_contains(x,'manager', ignore.case = TRUE) == TRUE) { return ('manager')}
  else if (str_contains(x,'director', ignore.case = TRUE) == TRUE) { return ('director')}
  else    { return ('na')}
}

df$job_simp = lapply(df$Job_Title, Title_Simplifier) 
table(as.character(df$job_simp))

### Seniority Parsing
Job_Seniority = function(x)
{
  if(  str_contains(x,'senior', ignore.case = TRUE) == TRUE || 
       str_contains(x,'sr', ignore.case = TRUE) == TRUE ||
       str_contains(x,'lead', ignore.case = TRUE) == TRUE ||
       str_contains(x,'principal', ignore.case = TRUE) == TRUE )
  { return ('senior')}
  else if ( str_contains(x,'jr', ignore.case = TRUE) == TRUE || 
            str_contains(x,'jr.', ignore.case = TRUE) == TRUE  )
  { return ('jr')}
  else { return('na') }
}

df$seniority = lapply(df$Job_Title, Job_Seniority) 
table(as.character(df$seniority))

### Hourly Wage Parsing
df$min_salary = apply(df, 1,function(x){ ifelse(x$hourly == 1, x$min_salary*2, x$min_salary) })
df$max_salary = apply(df, 1,function(x){ ifelse(x$hourly == 1, x$max_salary*2, x$max_salary) })

df[ df$hourly ==1 , c('hourly','min_salary', 'max_salary')]  

### To resolve write.csv error "unimplemented type 'list' in 'EncodeElement'"
### To avoid this, you should first check the data type for each column:
sapply(df, class)

### Use unlist() to fix the offending columns.
df$hourly = unlist(df$hourly)
df$job_simp = unlist(df$job_simp)
df$seniority = unlist(df$seniority)

write.csv(df,"E:\\Data Science\\01. Projects\\03. DataScience_Salary_Estimator\\Data_Cleaned.csv", row.names = FALSE)

remove(df, salary, Job_Seniority, Title_Simplifier)
