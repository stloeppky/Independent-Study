# reading in the data from 20 different CVS weather files 

library(plyr)
library(readr)

# reading all of the folders 
mydir = "osoyoos.folder"
myfiles = list.files(path=mydir, pattern="*.csv", full.names=TRUE)
myfiles

# now uploading all files as previously we only have the location 

osoyoos.climate = ldply(myfiles, read_csv)
osoyoos.climate

# oh my gosh! that worked and its all one big data file... 

# now selecting the columns for this heat map 

osoyoos.climate<- osoyoos.climate %>% 
  
  #arrange(-year) %>% 
  select(Year, Month, Day, `Mean Temp (°C)`)

head(osoyoos.climate)

# now making months with names 

month.abb

# for some reason I can't seem to turn this into months. I did it before but can't 
#figure out what the difference is 

# renaming a column 
names(osoyoos.climate)[4] <- "MeanTempC" 

# now I will see what it looks like plotted/If I can plot it 

osoyoos.plot <- ggplot(osoyoos.climate, aes(Year, Month)) +                        
  geom_tile(aes(fill = MeanTempC)) +
  scale_fill_gradient(low = "white", high = "red") +
  xlab("Year") +
  ylab("Month") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = NA))

# cant figure out how to make the legend title different 

osoyoos.plot

# I'm not sure if this this the best way to do this. I probably need to average each month? 










