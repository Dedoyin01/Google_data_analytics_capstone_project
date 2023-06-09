Google Capstone Project II: How Can Bellabeat Play It Smart?
Adedoyin Tiamiyu
2022-06-04

Bellabeat is a high-tech company that manufactures health-focused products for women, with the potential for growth in the global-smart economy, since 2013 and was founded by Urška Sršen and Sando Mur. Inspiring and empowering women with knowledge about their health and habits, Bellabeat has grown rapidly and quickly positioned itself as a tech-driven wellness company for females.
1. ASK
In this step, we define the problem and state the objectives of our case study.
Business Task
Analyze and discover trends in how the customers use the smart device to gain insight and help guide the Bellabeat marketing strategy for global growth.
Key Business questions
How do users use the smart device and how can the insight be used to help influence Bellabeat marketing strategy?
The analysis of the data provided will help identify opportunities for improvement in how users interact with the device and help make recommendations according to their needs.
Key Stakeholders
•	Urška Sršen: Bellabeat’s co-founder and Chief Creative Officer
•	Sando Mur: Mathematician and Bellabeat’s co-founder; a key member of the Bellabeat executive team
•	Bellabeat marketing analytics team: The marketing analyst team
•	The customers (External Stakeholders)

2. PREPARE
Data Source Information
The data used is publicly available on Kaggle; Fitbit Fitness Tracker Data, the dataset was generated by respondents to a distributed survey via Amazon Mechanical Turk between 12 March 2016 to 12 May 2016 and stored in 18 CSV files. Thirty FitBit users consented to the submission of personal tracker data and the data collected includes physical activity recorded in minutes, heart rate, sleep monitoring, daily activity, and steps. Data Credibility and Integrity
I will use the “ROCCC” system to determine the credibility and integrity of the datasets.
•	Reliability: This data is not reliable because it has only 30 respondents which means that the data might not represent a major part of the fitness population and makes the data biased.
•	Originality: This is not an original dataset as it was originally collected from a third party (Amazon Mechanical Murk).
•	Comprehensiveness: This data is not comprehensive. There is no information about the participants, such as gender, age, health state, etc. This could mean that data was not randomized.
•	Current: The data was collected five years ago which makes it outdated and may not represent the current trends in smart device usage.
•	Cited: As stated before, Amazon Mechanical Murk created the dataset, but we have no information on whether this is a credible source.
The dataset is not ROCCC and it is not recommended for producing reliable insights for making business decisions.
Limitations of Data
•	The data has a small sample size with only and does not represent the entire fitness population.
•	Bellabeat is a company that is focused on women’s products but there are no genders revealed in this dataset. Others key pieces of information missing include the users’ ages and the region where the data was collected.

3. PROCESS
Loading and Installing Packages
I will be using these packages for the analysis
•	tidyverse
•	lubridate
•	here
•	skimr
•	janitor
•	ggpubr
•	dplyr
•	ggplot2
library(tidyverse)
library(lubridate)
library(here)
library(skimr)
library(janitor)
library(ggpubr)
library(dplyr)
library(ggplot2)

Importing Dataset
daily_activity <- read.csv("dailyActivity_merged.csv")
daily_calories <- read.csv("dailyCalories_merged.csv")
daily_intensities <- read.csv("dailyIntensities_merged.csv")
daily_steps <- read.csv("dailySteps_merged.csv")
daily_heartrate <- read.csv("heartrate_seconds_merged.csv")
daily_sleep <- read.csv("sleepDay_merged.csv")
daily_weight <- read.csv("weightlogInfo_merged.csv")
Note that the echo = FALSE parameter was added to the code chunk to prevent printing of the R code that generated the plot.
Data Cleaning, Manipulation, and Exploring

Viewing Datasets
str(daily_activity)
str(daily_calories)
str(daily_heartrate)
str(daily_intensities)
str(daily_sleep)
str(daily_weight)

Cleaning Dataset

checking for numbers of the unique ID in each dataframes
n_distinct(daily_activity$Id) 
n_distinct(daily_calories$Id)  
n_distinct(daily_intensities$Id) 
n_distinct(daily_steps$Id)
n_distinct(daily_heartrate$Id)
n_distinct(daily_sleep$Id)  
n_distinct(daily_weight$Id)

Checking for duplicates
sum(duplicated(daily_activity))
sum(duplicated(daily_calories))
sum(duplicated(daily_heartrate))
sum(duplicated(daily_intensities))
sum(duplicated(daily_sleep))
sum(duplicated(daily_weight))

Checking for Na
sum(is.na(daily_activity))
sum(is.na(daily_calories))
sum(is.na(daily_intensities))
sum(is.na(daily_heartrate))
sum(is.na(daily_sleep))
sum(is.na(daily_weight))


Observations from exploring the datasets
•	daily_calories, daily_intensities, and daily_steps are merged into daily_activity.
•	daily_activity and daily_sleep have 33 and 24 unique IDs instead of 30.
•	daily_sleep has 3 duplicates.
•	daily_weight has too many missing values (65).
•	The date data type is wrongly classified as a character.
•	The variable name doesn’t fit the naming convention.
•	Some rows have zeros in total steps, which could mean that no distance was covered.
•	Total distance and Tracker Distance on the daily_activity dataframe have the same data, and tracker distance will be removed later in the analysis.
•	Logged activity distance on daily_activity dataframe has too many zeros which could mean that the users didn’t log in their info. The column will be dropped later.

4. ANALYSE

For this analysis, I will be focusing on the daily_activity and daily_sleep dataframe as they are the datasets that will help discover trends and give useful insights.
Data Manipulation (daily_activity)
Viewing the Dataset
str(daily_activity)
n_distinct(daily_activity$Id) 
sum(duplicated(daily_activity))
sum(is.na(daily_activity))
•	Dataset has 940 observations and 15 variable.
•	There are no missing values.
•	There are 33 unique IDs.
•	ActiviyDate is wrongly as character and the date format is wrong.
Converting date format and data type
daily_activity$ActivityDate <- format(as.Date(daily_activity$ActivityDate,
                                              format = "%m/%d/%Y"), "%Y-%m-%d")
Dropping some variables
daily_activity <- daily_activity %>%
  select(-TrackerDistance, -LoggedActivitiesDistance) %>% 
  subset()
To get the total active minute I will sum up the active minutes aside from the sedentary minutes.
daily_activity$total_active_minutes <- rowSums(cbind(daily_activity$VeryActiveMinutes,
                                                     daily_activity$FairlyActiveMinutes,
                                                     daily_activity$LightlyActiveMinutes)) 

Renaming the column names to fit the naming convention
daily_activity <- daily_activity %>%
  rename(Date = ActivityDate, total_steps = TotalSteps, total_distance = TotalDistance,
         very_active_distance = VeryActiveDistance,
         moderately_active_distance = ModeratelyActiveDistance, light_active_distance =
           LightActiveDistance,
         sedentary_active_distance = SedentaryActiveDistance, very_active_minutes =
           VeryActiveMinutes,
         fairly_active_minutes = FairlyActiveMinutes, sedentary_minutes = SedentaryMinutes,
         light_active_minutes = LightlyActiveMinutes, calories = Calories)
I found some cells with “0” values, so I will omit these to prevent misleading results.
daily_activity <- daily_activity %>% 
  filter(total_steps !=0, total_distance !=0, total_distance !=0)
Changing total active minutes to hours and sedentary minutes to hours
daily_activity <- daily_activity %>%
  mutate(total_active_hours = total_active_minutes / 60, 
         sedentary_hours = sedentary_minutes / 60 )
Adding the days of the week, for the visualization
daily_activity <- daily_activity %>%
  mutate(days = strftime(daily_activity$Date, "%A"))

Data Manipulation (daily_sleep)
Viewing dataset
str(daily_sleep)
n_distinct(daily_sleep$Id) 
sum(duplicated(daily_sleep))
sum(is.na(daily_sleep))
•	Dataset has 413 observations and 5 variable.
•	There are no missing values.
•	There are 24 unique IDs.
•	Sleepday is wrongly as character and the date format is wrong.
•	They are 3 duplicates
The date and time are in the same column in the daily_sleep dataframe and I will be splitting them with the separate () function and converting the date format and data type.
daily_sleep <- daily_sleep %>% 
  separate(SleepDay, c("Date", "time"), " ")
daily_sleep$Date <- format(as.Date(daily_sleep$Date, 
                                         format = "%m/%d/%Y"), "%Y-%m-%d")
I will also discard the time column because the timestamp is all midnight which could mean it is a fixed time for the logs.
Dropping the time column
daily_sleep <- daily_sleep %>%
  select(-time) %>%
  subset()
Removing duplicates
daily_sleep <- daily_sleep %>%
  distinct()

sum(duplicated(daily_sleep))
## [1] 0
nrow(daily_sleep)
## [1] 410
Renaming the column names to fit the naming convention
daily_sleep <- daily_sleep %>%
  rename(total_mins_asleep = TotalMinutesAsleep, 
         total_sleep_rec = TotalSleepRecords,
         total_mins_in_bed = TotalTimeInBed)
changing minutes to hours in the daily _sleep dataset
daily_sleep <- daily_sleep %>% 
  mutate(total_hrs_asleep = total_mins_asleep / 60,
         total_hrs_in_bed = total_mins_in_bed / 60)
Checking and filtering out for ‘0’
daily_sleep <- daily_sleep %>%
  filter(total_sleep_rec !=0, total_hrs_in_bed !=0, total_hrs_asleep !=0)
Statistical Ananlysis

I will be merge the daily_activity and daily_sleep for my analysis.

activity_sleep <- merge(daily_activity, daily_sleep, by = c("Id", "Date"))
Statistical Summary for activity_sleep dataframe
activity_sleep%>%
  select(total_steps, total_distance, very_active_distance, moderately_active_distance,
  light_active_distance,sedentary_active_distance, very_active_minutes, fairly_active_minutes, light_active_minutes, sedentary_minutes,sedentary_hours, total_active_minutes, total_active_hours, total_sleep_rec, total_mins_asleep, total_hrs_asleep, total_mins_in_bed, total_hrs_in_bed, calories) %>%
  summary()

Statistical Summary Interpretation
•	Average steps logged by the users is 8,329 which means they were somewhat active and according to a 2011 study found that healthy adults can take anywhere between approximately 4,000 and 18,000 steps/day and that 10,000 steps/day is a reasonable target for healthy adults. Source: https://www.healthline.com/health/how-many-steps-a-day
•	The average total distance covered is 5.986km daily.
•	Much of the distance covered was light active (3.643 km).
•	Most of the active time covered was light active by 210.3 mins or 3.5hrs.
•	The average time users spent being sedentary is 712.1 mins or 11.87 hrs which is more than the average total active time (259.5 mins or 4.3 hrs), which means the users were largely inactive or they spent less time exercising.
•	The users had 6.9 hours of sleep (419.2 mins), and the average total hrs in bed is 7.6 hrs (458.5 mins), the data shows that users spend an average of 39.3 minutes in bed before drifting off to sleep. “Normal sleep for adults means that you fall asleep within 10 to 20 minutes and get about 7–8 hours a night” which means users have an adequate amount of sleep. Source: https://www.healthline.com/health/healthy-sleep/how-long-does-it-take-to-fall-asleep
•	Average amount of calories burned is 2389 calories with a minimum of 257 calories and a maximum of 4900 calories.
I will look for a correlation between columns using the Pearson coefficient correlation ranging from +1 to -1.
#a. total_steps and total_distance
cor.test(activity_sleep$total_steps, activity_sleep$total_distance, method = "pearson" )
# b. total_steps and calories
cor.test(activity_sleep$total_steps, activity_sleep$calories, method = "pearson")
#c. total_active_hours and total_distance
cor.test(activity_sleep$total_distance, activity_sleep$total_active_hours, method = "pearson")
#d. total_active_hours and calories
cor.test(activity_sleep$total_active_hours, activity_sleep$calories, method = "pearson")
#e. sedentary_distance and calories 
cor.test(activity_sleep$sedentary_active_distance, activity_sleep$calories, method = "pearson")
#f. sedentary_hours and calories
cor.test(activity_sleep$sedentary_hours, activity_sleep$calories, method = "pearson")
#g. total_distance and sedentary_hours
cor.test(activity_sleep$total_steps, activity_sleep$sedentary_hours, method = "pearson")
#h. total_hrs_asleep and total_hrs_in_bed
cor.test(activity_sleep$total_hrs_asleep, activity_sleep$total_hrs_in_bed, method = 'pearson')
#i. total_hrs_asleep and calories
cor.test(activity_sleep$total_hrs_asleep, activity_sleep$calories, method = 'pearson')

a.	Total steps and total correlation is 0.9817539. This means that they have a very strong positive correlation showing that they increase in the same direction. This implies that total distance is derived from steps taken.
b.	Total Steps and calories correlation is 0.4063007. This means that have a positive moderate relationship.
c.	Total distance and total active correlation is 0.7223839. This means that they have a strong positive correlation showing that they increase in almost the same direction.
d.	Total active hours and calories correlation is 0.3899832. This means that they have a positive but weak relationship.
e.	Sedentary distance and calories correlation is 0.0284591. This means that they do not correlate.
f.	Sedentary hours and calories correlation is 0.0284591. This means that they do not correlate.
g.	Total active distance and sedentary hours correlation is -0.130036. This means that they have a negative correlation. The variables do not move in the same direction: one increases as the other decreases. Most likely as more distance is covered increases, sedentary hours decrease.
h.	Total hours asleep and total hours in bed correlation is 0.9304224. This means that they have a very strong positive correlation showing that they increase in the same direction. This implies that spending some time in bed helps the users fall asleep.
i.	Total hours asleep and calories correlation is -0.03169899. This means that the variables do not correlate.

5. SHARE
Data visualization
In this step, I will create visualizations to communicate the findings from my analysis
Daily log Frequency
ggplot(activity_sleep, aes(x=days))+
  geom_histogram(stat = "Count", color="black", fill="skyblue")+
  labs(title = "Daily Log Counts", x="Days of the week", y="Counts",caption =  "Date: 2016")
## Warning: Ignoring unknown parameters: binwidth, bins, pad
  
The highest log days were on Tuesdays, Wednesdays, and Thursdays but decreased during the weekend; from Friday to Sunday, and Monday.
Total steps per day
ggplot(data = activity_sleep, aes(x=days, y = total_steps, fill = days)) +
  geom_bar(stat = 'identity') +
  labs(title = "Total Steps Per Day", x= "Days of the week", y= "Total steps",
       caption = "Date: 2016")
  
From the graph bar above, we can see that Tuesday, Wednesday, and Thursday are the most active days for users. And the least active day for the user is Sundays.
Calories burnt per step
ggplot(data = activity_sleep, mapping = aes(x=total_steps, y=calories, color = calories )) +
  geom_point() +
  geom_smooth(method = "loess") +
  labs(title = "Calories Burnt Per Step", x = "Steps Taken", 
       y = "Calories Burned(kcal)", subtitle="Date: 2016")
## `geom_smooth()` using formula 'y ~ x'
  
From the graph above,
•	It shows that they have a positive correlation.
•	We can also see that the larger amount of steps taken, the more calories are burned.
Noted a few outliers:
•	Zero steps with zero to minimal calories burned.
•	1 observation of < 20,000 steps with < 5,000 calories burned.
•	The outliers could be due to natural variation of data, change in user usage, or errors in data collection (miscalculations, data contamination, or human error).
The relationship between steps taken and sedentary hours
ggplot(data = activity_sleep, mapping = aes(x=total_steps, y=sedentary_hours,
                                            color = sedentary_hours))+
  geom_point()+
  geom_smooth(method = 'loess')+
  labs(title = "The Relationship Between Steps Taken and Sedentary Time", caption = "Date:2016", x = "Steps Taken", y = "Sedentary Hour")
## `geom_smooth()` using formula 'y ~ x'
 
The graph above shows a negative correlation between total steps and sedentary hours, the higher the sedentary hours the lower the steps taken.
The relationship between total hours asleep and total hours in bed.
ggplot(data = activity_sleep)+
  geom_point(mapping = aes(x=total_hrs_asleep, y= total_hrs_in_bed), color= 'brown')+
  geom_smooth(mapping = aes(x=total_hrs_asleep, y= total_hrs_in_bed))+
  labs(title = "The Relationship Between Time Asleep and Time in Bed", caption = "Date:2016",
       x = "Total Hours Asleep", y = "Total Hours In Bed")
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
 
From the graph above, there is a positive correlation between the time asleep and the amount of time spent in bed, This implies that spending some time in bed helps the users fall asleep.
6. ACT

Key Findings
•	The users logged their activities more during mid-week days (Tuesday, Wednesday, and Thursday), more than on the weekends.
•	Most of the users spend the time being inactive.
•	Majority of users use the app to track sedentary activities more than they track tracking their active period.
•	Most of the users did not take enough steps to be considered active daily.
•	Most of all the users make use of their FitBit gadgets regularly while sleeping.

Recommendation
•	Since most users are only active on certain days and times. They can implement features that could help the users set a reminder for a specific time they would like to exercise daily.
•	Bellabeat could implement a push notification that can be used to remind the users to exercise on the weekends.
•	They can add a dairy feature where the users can document their daily activities.
•	They can create a menstrual tracking algorithm to help predict the next menstrual-cycle period and send a reminder to the users.
•	Upload articles to educate the user on different health habits and lifestyles, like daily calorie intake calculations, or food suggestions.
