######## Plot2 ########
##### Download and Charge Data ####
urlzip <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destzip <- paste(getwd(), "/Elec_power_cons.zip", sep = "")
download.file(urlzip, destzip, method = "curl")
unzip(destzip)

library(dplyr)
library(lubridate)

archivos <- list.files()
household_data <- read.table(grep(".txt$", archivos, value = T), sep = ";", header = T)
str(household_data)
for(i in 1:9){
    household_data[, i] <- gsub("^\\D", "NA",household_data[, i]) 
}
household_data <- as_tibble(household_data) 
household_data1 <- select(household_data,  3:9) %>% 
    sapply(function(x) as.numeric(x)) %>% 
    as_tibble()
household_data <- select(household_data, Date, Time)
household_data <- mutate(household_data, dates = paste(household_data$Date, household_data$Time))
household_data <- select(household_data, dates)
household_data <- strptime(household_data$dates, format = "%d/%m/%Y %H:%M:%S") 
household_data <- cbind(household_data, household_data1)
rm(household_data1)
household_data <- rename(household_data, dates = household_data)

elec_consumtion <- filter(household_data, dates>=as.POSIXct("2007-02-01"), dates<as.POSIXct("2007-02-03"))
elec_consumtion <- as_tibble(elec_consumtion)
rm(household_data)
# Just to check if it's rigth
min(elec_consumtion$dates)
max(elec_consumtion$dates)
#
##### Ploting code ######

png(filename = "Plot2.png")
with(elec_consumtion , plot(dates, Global_active_power, type="l", 
                            ylab="GlobalActive Power (kilowatts)",
                            xlab=""))
dev.off()

