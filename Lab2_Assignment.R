# Lab 2 Assignment: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Instructions ----

# 1. [40 points] Open the R file "Lab2_Script.R" comment each line of code with its purpose (with exception of Part 3)
# 2. [60 points] Open the R file "Lab2_Assignment.R" and answer the questions

#---- Q1. write the code to load the dataset "tract_covariates.csv" located under the "datasets" folder in your repository. Create an object called `opportunities` Use the data.table package to do this. ----
library(data.table)
opportunities<-fread("datasets/tract_covariates.csv")

data.table::fread("datasets/tract_covariates.csv")#another method

#---- Q2. On your browser, read and become familiar with the dataset metadata. Next write the code for the following:
# Link to metadata: https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf 


# what is the object class?
class(opportunities)
# how can I know the variable names?
names(opportunities)
# What is the unit of analysis? 
View(opportunities)#the analysis unit is "tract"?
# Use the `summary` function to describe the data. What is the variable that provides more interest to you?
summary(opportunities)#hhinc_mean2000  interests me more
# Create a new object called `sa_opportunities` that only contains the rows for the San Antonio area (hint: use the `czname` variable). 
sa_opportunities<-subset(opportunities,czname=="San Antonio")
sa_opportunities <- opportunities[opportunities$czname == "San Antonio", ]
sa_opportunities
# Create a plot that shows the ranking of the top 10 census tracts by Annualized job growth rate (`ann_avg_job_growth_2004_2013` variable) by census tract (tract variable). Save the resulting plot as a pdf with the name 'githubusername_p1.pdf' # Hint: for ordering you could use the `setorderv()` or reorder() functions, and the ggsave() function to export the plot to pdf. 
head(sa_opportunities)
class(sa_opportunities)
names(sa_opportunities)
top10 <- sa_opportunities[order(-ann_avg_job_growth_2004_2013)][1:10]
library(ggplot2)
ggplot(data=top10,aes(x=reorder(tract, ann_avg_job_growth_2004_2013),y=ann_avg_job_growth_2004_2013))+geom_bar(stat = "identity")
ggsave(filename="D:/UTSA/UTSA course/25-spring/PlanningMethodsII/lab-assignment/02-lab-assignment-pingyuan-utsa/02_lab/plots/githubusername_p1.pdf",plot=last_plot())

# Create a plot that shows the relation between the `frac_coll_plus` and the `hhinc_mean2000` variables, what can you hypothesize from this relation? what is the causality direction? Save the resulting plot as a pdf with the name 'githubusername_p3.pdf'
sa_opportunities <- na.omit(sa_opportunities, cols = c("frac_coll_plus2000", "hhinc_mean2000", "popdensity2000"))
ggplot(data=sa_opportunities,aes(x=frac_coll_plus2000,y=hhinc_mean2000,size=popdensity2000,color=share_white2000))+geom_point(alpha = 0.6)
#frac_coll_plus2000 is positively related to hhinc_mean2000,which means areas with a higher proportion of college-educated people tend to have higher mean household incomes.Popdensity might act as a hidden factor,which is negatively related with hhinc_mean2000
ggsave(filename="D:/UTSA/UTSA course/25-spring/PlanningMethodsII/lab-assignment/02-lab-assignment-pingyuan-utsa/02_lab/plots/githubusername_p3.pdf",plot=last_plot())

# Investigate (on the internet) how to add a title,a subtitle and a caption to your last plot. Create a new plot with that and save it as 'githubusername_p_extra.pdf'
ggplot(data=sa_opportunities,aes(x=frac_coll_plus2000,y=hhinc_mean2000,size=popdensity2000,color=share_white2000))+geom_point(alpha = 0.6)+labs(title = "Relationship Between College Education and Household Income",
       subtitle = "The impact of high education on household income",
       caption = "Data source:datasets/tract_covariates",
       x = "Proportion of Young People with High Education Per Track(2000)",
       y = "Mean Household Income (2000)",
       size = "Population Density",
       color = "White Population Share") 
ggsave(filename="D:/UTSA/UTSA course/25-spring/PlanningMethodsII/lab-assignment/02-lab-assignment-pingyuan-utsa/02_lab/plots/githubusername_p_extra.pdf",plot=last_plot())







