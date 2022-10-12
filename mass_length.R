
# Visualizing mass and length data in male and female rattlesnakes 
# Using data from 2021 as a practice - will later use all 20 years of data 

#reading in the CSV file from 2021 

cap2021.data <- read.csv(paste(p.data.raw, "capture.2021.csv", sep = ""))
str(cap2021.data)

# selecting just the variables that I want 

head(cap2021.data)

cap.2021 <- cap2021.data %>% 
  #arrange(-year) %>% 
  select(SVL, MASS, SEX, AGE.CLASS, DATE)

head(cap.2021)

# now looking at unique variable 

unique(cap.2021$AGE.CLASS) # "ADULT" "SUB ADULT" "JUVENILE"  "NEONATE"  
unique(cap.2021$SEX) # "F"   "M"   "UNKNOWN"   "F?"   NA   "TOO SMALL"

# fixing typos 

library(tidyverse)

cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "F?", "NA"))

cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "UNKNOWN", "NA"))

cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "TOO SMALL", "NA"))

cap.2021 <- na.omit(cap.2021)


# the rows that were NA because they were missing values were removed, but the rows that I named "NA"
# were not removed 
# going to try to remove the "NA" - Doesn't seem to be working 



# trying to plot 


plot(cap.2021$MASS, cap.2021$SVL)


# getting this error message Warning message: In xy.coords(x, y, xlabel, ylabel, log) : NAs introduced by coercion
# trying to solve 

str(cap.2021)

# hmmm why is mass a character? 
# there are characters in the data 
library(dplyr)
subset(cap.2021, MASS != "UNKNOWN") # tried this but it didnt seem to work 

head(cap.2021)



