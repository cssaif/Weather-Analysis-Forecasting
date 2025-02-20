# Load necessary libraries
library(httr)
library(jsonlite)
library(zoo)
library(dplyr)
library(ggplot2)
library(purrr)
library(xgboost)
library(lubridate)
library(caret)
library(tidyr)


# Define API URL for historical weather data
url <- "https://archive-api.open-meteo.com/v1/era5?latitude=24.6877&longitude=46.7219&start_date=2015-01-01&end_date=2025-02-15&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m,cloudcover,precipitation,dewpoint_2m,pressure_msl,wind_gusts_10m&timezone=auto"

# Fetch data from API
response <- GET(url)
data <- fromJSON(content(response, "text"))

# Convert API response to a dataframe
weather_data <- as.data.frame(data$hourly)
weather_data$time <- as.POSIXct(weather_data$time, format="%Y-%m-%dT%H:%M", tz="UTC")
weather_data <- weather_data %>% filter(!is.na(time))


# Calculate temperature change from previous hour
weather_data <- weather_data %>%
  arrange(time) %>%
  mutate(temp_change = temperature_2m - lag(temperature_2m))


# Extract month for seasonal analysis
weather_data <- weather_data %>%
  mutate(month = as.numeric(format(time, "%m")))

