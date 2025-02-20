#Assume weather_data is already available in memory. If not, load from weather_collection_script.

# 1️⃣ Correlation Analysis Per Season
season_list <- list(
  winter = filter(weather_data, month %in% c(12,1,2)),
  spring = filter(weather_data, month %in% c(3,4,5)),
  summer = filter(weather_data, month %in% c(6,7,8)),
  fall = filter(weather_data, month %in% c(9,10,11))
)

# Function to Compute and Print Correlation
compute_correlation <- function(season_name, season_data) {
  cor_matrix <- cor(season_data %>% select(where(is.numeric)), use = "complete.obs")
  
  cat("\n=======================\n")
  cat("📌 Correlation Matrix for", season_name, "\n")
  cat("=======================\n")
  print(cor_matrix["temperature_2m", ])  # Show only correlations with temperature
  
  invisible(NULL)  # Prevents lapply() from returning unnecessary output
}

# Run correlation analysis for each season
invisible(lapply(names(season_list), function(name) compute_correlation(name, season_list[[name]])))


# 2️⃣ Linear Regression Models Per Season
# Define Models
season_models <- list(
  winter = lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + humidity_squared + pressure_msl + dewpoint_2m,
              data = season_list$winter),
  
  spring = lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + humidity_squared + pressure_msl + dewpoint_2m,
              data = season_list$spring),
  
  summer = lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + humidity_squared + pressure_msl + dewpoint_2m,
              data = season_list$summer),
  
  fall = lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + humidity_squared + pressure_msl + dewpoint_2m,
            data = season_list$fall)
)

# Function to Print Model Summary
summarize_model <- function(season_name, model) {
  cat("\n=======================\n")
  cat("📌 Model Summary for", season_name, "\n")
  cat("=======================\n")
  print(summary(model))
}

# Run model summary for each season
lapply(names(season_models), function(name) summarize_model(name, season_models[[name]]))