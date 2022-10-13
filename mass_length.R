
# Visualizing mass and length data in male and female rattlesnakes 
# Using data from 2021 as a practice - will later use all 20 years of data 

#reading in the CSV file from 2021 

cap2021.data <- read.csv(paste(p.data.raw, "capture.2021.csv", sep = ""))

# this is just needed for me as the data file is in same directory as 
# the code (not a proper project yet on my computer)
cap2021.data <- read.csv("capture.2021.csv")

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

# NA should be NA,. not "NA"
cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "F?", NA))

cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "UNKNOWN", NA))

cap.2021 <- cap.2021 %>%
  mutate(SEX = replace(SEX, SEX== "TOO SMALL", NA))

is.na(cap.2021$SEX)
cap.2021 <- na.omit(cap.2021)


# the rows that were NA because they were missing values were removed, but the rows that I named "NA"
# were not removed 
# going to try to remove the "NA" - Doesn't seem to be working 



# trying to plot 


plot(cap.2021$MASS, cap.2021$SVL)

# PROBLEMS! check first if the variable is numeric
class(cap.2021$MASS) # ..... character!
# somebody added "UNKNOWN".... come on!
cap.2021 <- cap.2021 %>%
  mutate(MASS = replace(MASS, MASS== "UNKNOWN", NA))
cap.2021$MASS <- as.numeric(cap.2021$MASS)
class(cap.2021$MASS)
# perfect, numeric
# same for length
class(cap.2021$SVL)
# that looks fine
# let's remove the missing value rows again

cap.2021 <- na.omit(cap.2021)

# let's try again
plot(cap.2021$MASS, cap.2021$SVL)
# beauty works.

# going to make males aand females in separate dataframes
female <- cap.2021[cap.2021$SEX == "F",]
male <- cap.2021[cap.2021$SEX == "M",]

# now we need to do some trickery to make the axis proper range.
x.lim <- range(cap.2021$MASS) # range for x axis
y.lim <- range(cap.2021$SVL)  # range for y axis

# make plot
plot(NA, xlim = x.lim, ylim = y.lim, xlab = "Mass (gram?)", ylab = "SVL")
# now plot using points females and then males
points(female$MASS, female$SVL, col = "red", pch = 19)
points(male$MASS, male$SVL, co = "purple", pch = 19)

# we got something going! keep on working with it.



# getting this error message Warning message: In xy.coords(x, y, xlabel, ylabel, log) : NAs introduced by coercion
# trying to solve 

str(cap.2021)

# hmmm why is mass a character? 
# there are characters in the data 
library(dplyr)
subset(cap.2021, MASS != "UNKNOWN") # tried this but it didnt seem to work 

head(cap.2021)



