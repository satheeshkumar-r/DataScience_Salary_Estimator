
#install.packages('fastDummies')
#install.packages('Metrics')

library(fastDummies)  # To create Dummy Variables
library(caTools)      # Splitting data into Training set & Test set
library(Metrics)      # For Calculating Root Mean Squared Error
library(rpart)        # For Decision Tree Regression
library(randomForest) # For Random Forest Regression

setwd('E:/Data Science/01. Projects/03. DataScience_Salary_Estimator')

df = read.csv('05. Data_Cleaned.csv')

### Choose relevant columns 
colnames(df)
df_model = df[ df$job_simp == 'data scientist' ,c('job_state', 'job_simp',  'seniority', 'avg_salary')]

### Adding dummy variables
colnames(df_model)
df_dum <- dummy_cols(df_model, select_columns = c('job_state', 'job_simp','seniority'), 
                        remove_selected_columns = TRUE)
colnames(df_dum)

### Splitting dataset into training set and test set
set.seed(123)
split = sample.split(Y = df_dum$avg_salary, SplitRatio = 0.8 )

Training_Data = subset(df_dum, split == TRUE)
Test_Data = subset(df_dum, split == FALSE)

### Multi-Linear Regression
M_regressor = lm(formula = avg_salary ~ . ,
                    data = Training_Data )

summary(M_regressor)      

Y_Mpred =  predict(M_regressor, newdata = Training_Data)

rmse(Training_Data$avg_salary, Y_Mpred)

### Decision Tree Regression 
DT_Regressor = rpart (formula = avg_salary ~.,
                      data = Training_Data,
                      control = rpart.control(minsplit = 2))

Y_DTpred = predict(DT_Regressor, newdata = Training_Data )  

rmse(Training_Data$avg_salary, Y_DTpred)

### Random Forest Regression 
RF_Regressor = randomForest( x = Training_Data[-c(3)],
                             y = Training_Data$avg_salary,
                             ntree = 5)

Y_RFpred = predict(RF_Regressor, newdata = Training_Data )  

rmse(Training_Data$avg_salary, Y_RFpred)

# Test Ensembles 
Y_Test_Mpred =  predict(M_regressor, newdata = Test_Data)
Y_Test_DTpred = predict(DT_Regressor, newdata = Test_Data )  
Y_Test_RFpred = predict(RF_Regressor, newdata = Test_Data )  

rmse(Test_Data$avg_salary, Y_Test_Mpred)
rmse(Test_Data$avg_salary, Y_Test_DTpred)
rmse(Test_Data$avg_salary, Y_Test_RFpred)

remove(df, df_dum, df_model, DT_Regressor, M_regressor, RF_Regressor, Test_Data, Training_Data, split, Y_DTpred, Y_Mpred, Y_RFpred, Y_Test_DTpred, Y_Test_Mpred, Y_Test_RFpred)

