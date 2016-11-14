library(sqldf)
library(lubridate)

##Setting Up the Workspace
#Create a directory for the data to be stored if one does not exist already
if(!file.exists("./data")){dir.create("./data")}

##Downloading Data
#Download dataset and unzip
fileurl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
download.file(fileurl, "./data/dataset.zip")
setwd("data")
unzip("./dataset.zip")

fi <- file("household_power_consumption.txt")

#Query the datafile to only select the two dates used in the exploratory analysis
powerconsum <- sqldf("SELECT * FROM fi WHERE Date = '1/2/2007' OR Date = '2/2/2007'",
                     file.format = list(header = TRUE, sep = ";"))
close(fi)

setwd('..')

#Tidy the data set
names(powerconsum) <- tolower(names(powerconsum))
names(powerconsum) <- gsub("_","",names(powerconsum))

#Convert dates and time
powerconsum$date <- dmy(powerconsum$date)
powerconsum$datetime <- paste(powerconsum$date, powerconsum$time)
powerconsum$datetime <- strptime(powerconsum$datetime, format = "%Y-%m-%d %H:%M:%S")

##Construct the plot
#Open the PNG device in the working directory
png(filename = "plot3.png", width = 480, height = 480)
with(powerconsum, plot(datetime, submetering1,  type = "l", xlab = "",ylab = "Energy sub metering"))
with(powerconsum,lines(datetime, submetering2,  type = "l", col = "red"))
with(powerconsum,lines(datetime, submetering3,  type = "l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1,1,1))
dev.off()