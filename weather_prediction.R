forecast_horizon <- 168

future_times <- seq(
  max(weather_data$time, na.rm = TRUE) + hours(1), 
  by = "hour", 
  length.out = forecast_horizon
)

future_forecasts <- data.frame(time = future_times)

#Normalization (Disabled: XGBoost does not require it)
# weather_data <- weather_data %>%
#   mutate(across(c(temperature_2m, wind_speed_10m, relative_humidity_2m, pressure_msl, dewpoint_2m), scale))
#Normalization hurt performance by disrupting natural temperature patterns.


# Function to create lagged features with interactions
create_lagged_features <- function(data, target_col, lags = 24) {
  df <- data.frame(target = data[[target_col]])  # Start with target column
  
  # Create standard lagged values for temperature
  for (i in 1:lags) {
    df[[paste0("lag_", i)]] <- lag(data[[target_col]], i)
    
  }
  for (i in 1:lags) {
    # Lag interactions with other weather variables
    df[[paste0("temp_humidity_lag_", i)]] <- lag(data$temperature_2m * data$relative_humidity_2m, i)
    df[[paste0("temp_wind_speed_lag_", i)]] <- lag(data$temperature_2m * data$wind_speed_10m, i)
    df[[paste0("temp_pressure_lag_", i)]] <- lag(data$temperature_2m * data$pressure_msl, i)
    df[[paste0("temp_dewpoint_lag_", i)]] <- lag(data$temperature_2m * data$dewpoint_2m, i)
  }
  
  df <- na.omit(df)  # Remove missing values
  return(df)
}

# Define the target variable
target_var <- "temperature_2m"

# Create lagged features for temperature prediction
weather_lagged <- create_lagged_features(weather_data, target_var)

# Split data into training and testing sets
split_index <- round(0.8 * nrow(weather_lagged))
train_set <- weather_lagged[1:split_index, -1]  # Features
test_set <- weather_lagged[(split_index + 1):nrow(weather_lagged), -1]

train_labels <- weather_lagged[1:split_index, 1]  # Target variable
test_labels <- weather_lagged[(split_index + 1):nrow(weather_lagged), 1]

# Train the XGBoost model for temperature
train_matrix <- xgb.DMatrix(data = as.matrix(train_set), label = train_labels)

# Regularization (Disabled: It restricted the model too much)
# lambda = 1,   # L2 Regularization (Ridge) - Prevents overfitting but was too aggressive
# alpha = 0.5,  # L1 Regularization (Lasso) - Removes weak features but didn't help
# gamma = 10,   # Prevents excessive splits but limited the model's ability to learn trends
# Regularization made the model underfit and increased MAE instead of reducing it.

xgb_model <- xgboost(
  data = train_matrix,
  max_depth = 3,  
  learning_rate = 0.01,  
  nrounds = 500,  
  objective = "reg:squarederror",
  verbose = 0
)

# Make predictions
test_matrix <- xgb.DMatrix(data = as.matrix(test_set))
predictions <- predict(xgb_model, newdata = test_matrix)

# Calculate RMSE
rmse_value <- RMSE(predictions, test_labels)
print(rmse_value)

# Update future_forecasts with temperature predictions
future_forecasts$temperature_2m <- tail(predictions, forecast_horizon)

comparison_df <- merge(new_weather_data, future_forecasts, by = "time")
comparison_df <- comparison_df %>% 
  rename(actual_temp = temperature_2m.x, predicted_temp = temperature_2m.y) %>% 
  mutate(temp_diff = actual_temp - predicted_temp)

mean(abs(comparison_df$actual_temp - comparison_df$predicted_temp), na.rm = TRUE)
RMSE(comparison_df$actual_temp, comparison_df$predicted_temp, na.rm = TRUE)
