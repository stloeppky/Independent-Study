
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
plot(NA, xlim = x.lim, ylim = y.lim, xlab = "Mass (gram)", ylab = "Snout to Vent Length (cm)")

# now plot using points females and then males
points(female$MASS, female$SVL, col = "red", pch = 19)
points(male$MASS, male$SVL, co = "purple", pch = 19)

# we got something going! keep on working with it.


# trying to add trend lines to male vs female 
abline(lm(female$SVL ~female$MASS), col = "red")
abline(lm(male$SVL ~male$MASS), col = "purple")

# so from this the male and female trends are super similar - obviously they are not linear so trying to figure
#out how to change that 

# curious about what the group is at the top as it seems to be both males and females 
# the largest snakes in both length and mass are males 

# can't figure out how to make a logorithmic regression line.... 

# trying in ggplot because its easier for me to use for some reason 
library(ggplot2)

ggplot(cap.2021, aes(x = MASS, y = SVL, colour = SEX)) +
  geom_point() + 
  geom_smooth(se = FALSE) +
  xlab("Mass (g)") +             
  ylab("Snout to Vent Length (cm)") + 
  scale_color_discrete("Sex") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))


# this does it for both F & M but trying to see how it might be different 

# I would like to make this a logarithmic line or something else but unsure how 


# trying box plot 

ggplot(cap.2021, aes(x=MASS, y=SVL, fill = SEX)) + geom_boxplot()

# Just two big plots - does not show the data well 

# trying to bin some data so that I can see more detail 

library(dplyr)

cap.2021 <- cap.2021 %>% mutate(MASS_bin = cut(MASS, breaks=10))


# making a boxplot with the binned data 

head(cap.2021) 

ggplot(cap.2021, aes(x= MASS_bin, y = SVL, fill = SEX, colour = SEX)) + geom_boxplot() +
  geom_smooth(se=FALSE, aes(group=1),) +
  theme(axis.text.x = element_text(angle = 90)) +
  ylim(0, 110) +
  xlab("Mass (g)") +             
  ylab("Snout to Vent Length (cm)") + 
  scale_color_discrete("Sex") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
       panel.background = element_blank(), axis.line = element_line(colour = "black"))
# tried   geom_smooth(method = "lm", se=FALSE, color="black", aes(group=1)) but I dont like this line 
# trying different method. Removed method = lm - shows a moving trendline which looks more accurate I think
# I still want to put two different trendlines for female and male 
#using Fill and Colour in the ggplot section created two different legends... which is interesting... 

# making this plot again but with two different plots for male and female 
ggplot(cap.2021, aes(x= female$MASS, y = female$SVL)) + 
  geom_point()


# went back and put color = SEX into ggplot portion of the script, and that made it apply to
# both the points and the lines 











