## call ness lib
library(lubridate)
library(tidyr)
## set locale for English weekdays
Sys.setlocale("LC_ALL","English")
## check for file already been downloaded
if (!file.exists("datazip.zip")) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, "datazip.zip")
}
if (!file.exists("household_power_consumption.txt")) {
        unzip("datazip.zip", "household_power_consumption.txt")
}
## get names from the first row
cnames <- names(read.table("household_power_consumption.txt", nrow=1, header=TRUE, sep=";"))
## find the right number of rows to skip
rskip <- grep("^1/2/2007", readLines("household_power_consumption.txt"))
rskip <- rskip[1]-1
## find the right number of rows to load
rlast <- grep("^3/2/2007", readLines("household_power_consumption.txt"))
rlast <- rlast[1]-1
nrow <- rlast-rskip
## loading data
data1 <- read.table("household_power_consumption.txt", na.strings = "?", sep = ";", header = FALSE, col.names = cnames, skip = rskip, nrow = nrow)
## create date+time column for futher lubridate parsing
data1 <- unite(data1, sdate, c(Date, Time), sep = "_")
data1 <- mutate(data1, pdate = dmy_hms(sdate))
## plotting to png
png(file = "Plot4.png")
par(mfrow = c(2,2))
## plot1
plot( data1$pdate, data1$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
## plot2
plot( data1$pdate, data1$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
## plot3
plot( data1$pdate, data1$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub merering")
points(data1$pdate, data1$Sub_metering_2, type = "l", col = "Red")
points(data1$pdate, data1$Sub_metering_3, type = "l", col = "Blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red","blue"), lty = c(1,1,1), lwd = c(1,1,1), bty = "n")
## plot4
plot( data1$pdate, data1$Global_active_power, type = "l", xlab = "datetime", ylab = "Global_active_power")
dev.off()