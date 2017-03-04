#set working directory

#read dataset in
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataset_url, "electricpowerconsumption.zip")
unzip("electricpowerconsumption.zip", exdir = "electricpowerconsumption")

library(dplyr)
library(data.table)

#read file
data <- data.table(read.table("electricpowerconsumption/household_power_consumption.txt", 
                   sep = ";", 
                   col.names = c("Date", "Time", "Global_active_power", 
                                 "Global_reactive_power","Voltage","Global_intensity",
                                 "Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
                   skip = 1, 
                   stringsAsFactors = FALSE, 
                   na.strings = "?"))

#filter data to only include 2/1/2007 and 2/2/2007
filtered_data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")

#re-format dates and times
filtered_data$Date <- as.Date(filtered_data$Date, "%d/%m/%Y")
filtered_data$Time <- format(filtered_data$Time, format = "%H:%M:%S")

filtered_data$Date_Time <- as.POSIXct(paste(filtered_data$Date, filtered_data$Time), format="%Y-%m-%d %H:%M:%S")

#plot 4
windows()
par(mfrow = c(2,2))
plot(filtered_data$Date_Time, filtered_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power", col = "black")
plot(filtered_data$Date_Time, filtered_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage", col = "black")
plot(filtered_data$Date_Time, filtered_data$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", col = "black")
lines(filtered_data$Date_Time, filtered_data$Sub_metering_2, type = "l", xlab = "", col = "red")
lines(filtered_data$Date_Time, filtered_data$Sub_metering_3, type = "l", xlab = "", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(filtered_data$Date_Time, filtered_data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", col = "black")
dev.copy(png, "plot4.png", width = 480, height = 480)
dev.off()
