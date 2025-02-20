# 1️⃣ Feature Engineering: Add Humidity²
weather_data <- weather_data %>%
  mutate(humidity_squared = relative_humidity_2m^2)

set.seed(123)  # Ensure reproducibility
train_indices <- sample(nrow(weather_data), 0.8 * nrow(weather_data))
train_data <- weather_data[train_indices, ]
test_data <- weather_data[-train_indices, ]

# 3️⃣ Train Separate Seasonal Models
model_winter <- lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + pressure_msl + dewpoint_2m, 
                   data = filter(train_data, month %in% c(12,1,2)))

model_spring <- lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + pressure_msl + dewpoint_2m, 
                   data = filter(train_data, month %in% c(3,4,5)))

model_summer <- lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + pressure_msl + dewpoint_2m, 
                   data = filter(train_data, month %in% c(6,7,8)))

model_fall <- lm(temperature_2m ~ wind_speed_10m + relative_humidity_2m + pressure_msl + dewpoint_2m, 
                 data = filter(train_data, month %in% c(9,10,11)))

# Extract coefficients from each seasonal model
coefs_winter <- coef(model_winter)
coefs_spring <- coef(model_spring)
coefs_summer <- coef(model_summer)
coefs_fall <- coef(model_fall)

# Combine them into a dataframe for comparison
seasonal_coefs <- data.frame(
  Variable = names(coefs_winter),
  Winter = coefs_winter,
  Spring = coefs_spring,
  Summer = coefs_summer,
  Fall = coefs_fall
)

# Print coefficients to analyze
print(seasonal_coefs)

# Convert to long format for ggplot
seasonal_coefs_long <- seasonal_coefs %>%
  pivot_longer(cols = Winter:Fall, names_to = "Season", values_to = "Coefficient") %>% 
  filter(Variable != "(Intercept)")

variable_labels <- c(
  "dewpoint_2m" = "Dewpoint",
  "pressure_msl" = "Pressure",
  "relative_humidity_2m" = "Humidity",
  "wind_speed_10m" = "Wind Speed"
)

# Modify the ggplot visualization
ggplot(seasonal_coefs_long, aes(x = Variable, y = Coefficient, fill = Season)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Effect of Weather Variables on Temperature by Season",
       y = "Regression Coefficient",
       x = "Weather Variable") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_discrete(labels = variable_labels)