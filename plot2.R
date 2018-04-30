# Checks for and installs required packages
if(!require("data.table"))
    install.packages("data.table")
if(!require("tidyr"))
    install.packages("tidyr")
require(data.table)
require(tidyr)

# Checks if file has been installed already. If not, data is installed and unzipped
file <- "HouseholdPowerConsumption.zip"
if(!file.exists(file))
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = file)
if(!file.exists("household_power_consumption.txt"))
    unzip(file)

#Reads in the data and formats the table as desired, creates one datetime column from the date and time columns
consumption <- fread("household_power_consumption.txt", sep = ';', header = TRUE, na.strings = c("?"))
cons <- consumption[consumption$Date == "1/2/2007" | consumption$Date == "2/2/2007"]
cons$Date <- as.Date(cons$Date, "%d/%m/%Y")
cons <- unite(cons, "temp_datetime", c("Date", "Time"), sep = " ")
datetime <- strptime(cons$temp_datetime, format = "%Y-%m-%d %H:%M:%S")
cons <- cbind(datetime, cons)
cons <- subset(cons, select = -temp_datetime)

#Creates the graph
png("plot2.png", width = 480, height = 480)
plot(cons$datetime, cons$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()