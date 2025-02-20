# Define API URL for historical weather data
url <- "https://archive-api.open-meteo.com/v1/era5?latitude=24.6877&longitude=46.7219&start_date=2025-02-16&end_date=2025-02-19&hourly=temperature_2m&timezone=auto"

# Fetch data from API
response <- GET(url)
data <- fromJSON(content(response, "text"))

# Convert API response to a dataframe
new_weather_data <- as.data.frame(data$hourly)

new_weather_data$time <- as.POSIXct(new_weather_data$time, format="%Y-%m-%dT%H:%M", tz="UTC")
