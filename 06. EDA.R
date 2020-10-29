
# install.packages('pivottabler')

library(ggplot2)
library(pivottabler)

getwd()
setwd('E:/Data Science/01. Projects/03. DataScience_Salary_Estimator')

df = read.csv('05. Data_Cleaned.csv')

summary(df)

colnames(df)


### Histogram View
hist(df$Company_Rating)
hist(df$avg_salary)
hist(df$pd_hourly)

### Boxplot  View
boxplot(df$pd_hourly, df$avg_salary, df$Company_Rating)
boxplot(df$Company_Rating)

### Correlation View
cor(df[,c('avg_salary','pd_hourly')])

### Heatmap View
col = colorRampPalette(c('pink', 'white', 'red'))(256)
heatmap(cor(df[,c('pd_hourly','avg_salary')]), col = col)

### Barplot View
barplot(sort(table(df$City_State), decreasing = TRUE), col = rainbow(length(df$City_State)), las = 2, cex.names=0.5 )
barplot(sort(table(df$job_state), decreasing = TRUE), col = rainbow(length(df$job_state)), las = 2, cex.names=0.5 )

df_cat = df[ , c('Company_Name', 'City_State', 'job_state','job_simp', 'seniority')]

colindex = 0
for (col_name in df_cat) 
{
  #barplot(sort(table(col_name), decreasing = TRUE), col = rainbow(length(col_name)), las = 2 )
  
  colindex = colindex + 1  
  xlab_name = colnames(df_cat[colindex])
  df_CharCol = data.frame(sort(table(col_name), decreasing = TRUE))
  
  print( 
    ggplot(data=df_CharCol, aes(x = col_name, y = Freq, fill = col_name )) +
          geom_bar(stat="identity") +
          xlab(xlab_name)+
          ylab('Count')+
          theme(legend.position = "none")+
          theme(axis.text.x = element_text(angle = 90))
      )
}

df_catlong = df[ , c('Company_Name', 'City_State')]

colindex = 0
for (col_name in df_catlong) 
{
  colindex = colindex + 1  
  xlab_name = colnames(df_catlong[colindex])
  df_CharCol = data.frame(sort(table(col_name), decreasing = TRUE))
  df_CharCol  = df_CharCol[1:20 ,]
  
  print( 
    ggplot(data=df_CharCol, aes(x = col_name, y = Freq, fill = col_name )) +
      geom_bar(stat="identity") +
      xlab(xlab_name)+
      ylab('Count')+
      theme(legend.position = "none")+
      theme(axis.text.x = element_text(angle = 90))
  )
}

### Pivot table view
pt <- PivotTable$new()
pt$addData(df)
pt$addRowDataGroups('job_simp')
pt$defineCalculation(calculationName='Average salary', summariseExpression='mean(avg_salary)')
pt$renderPivot()

pt <- PivotTable$new()
pt$addData(df)
pt$addRowDataGroups('job_simp')
pt$addRowDataGroups('seniority')
pt$defineCalculation(calculationName='Average salary', summariseExpression='mean(avg_salary)')
pt$renderPivot()

pt <- PivotTable$new()
pt$addData(df)
pt$addRowDataGroups('job_state')
pt$addRowDataGroups('job_simp')
pt$defineCalculation(calculationName='Average salary', summariseExpression='mean(avg_salary)')
pt$sortRowDataGroups(levelNumber = 2,orderBy = "calculation",sortOrder = "desc")
pt$renderPivot()

pt <- PivotTable$new()
pt$addData(df)
pt$addRowDataGroups('job_state')
pt$addRowDataGroups('job_simp')
pt$defineCalculation(calculationName='Average salary', summariseExpression='n()')
pt$sortRowDataGroups(levelNumber = 2,orderBy = "calculation",sortOrder = "desc")
pt$renderPivot()

pt <- PivotTable$new()
pt$addData(df[df$job_simp == 'data scientist',])
pt$addRowDataGroups('job_state')
pt$defineCalculation(calculationName='Average salary', summariseExpression='mean(avg_salary)')
pt$sortRowDataGroups(levelNumber = 1,orderBy = "calculation",sortOrder = "desc")
pt$renderPivot()

pt <- PivotTable$new()
pt$addData(df)
pt$addRowDataGroups('Company_Rating')
pt$addColumnDataGroups('job_simp')
pt$defineCalculation(calculationName='Average salary', summariseExpression='n()')
pt$renderPivot()

remove(df, df_CharCol, colindex, xlab_name, df_cat, col, col_name, df_catlong, pt )




