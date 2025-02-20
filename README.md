# Weather-Analysis-Forecasting
This project analyzes weather trends and forecasts temperature using XGBoost. Seasonal models assess how humidity, wind speed, pressure and dewpoint impact temperature. Using lag features, it predicts up to 7 days ahead with an MAE of 2.65°C.
📌 Project Title:
Weather Analysis & Forecasting with XGBoost and Seasonal Models

📝 Description:
This project is a two-part analysis and machine learning model designed to analyze historical weather data and predict future temperatures using XGBoost and seasonal regression models.

### Part 1: Seasonal Weather Analysis
Explores how humidity, wind speed, pressure, and dewpoint influence temperature across different seasons. Uses seasonal linear regression models to highlight key trends in winter, spring, summer, and fall. Visualizes the effects of different weather factors over time.

### Part 2: Machine Learning Temperature Forecasting
Transforms time-series data using lag features and weather interactions. Trains an XGBoost model to predict temperature 7 days ahead. Evaluates performance using Mean Absolute Error (MAE) and Root Mean Square Error (RMSE).

📂 Files in This Repository
| File | Description |
|------|------------|
| fetch_current_weather.R | Fetches real-time weather data from Open-Meteo API. |
| weather_collection_script.R | Collects historical weather data for model training. |
| temperature_factors_by_season.R | Analyzes how weather variables affect temperature in each season. |
| seasonal_models.R | Builds seasonal regression models to study trends. |
| weather_prediction.R | Trains the XGBoost model and makes temperature predictions. |

🛠️ Technologies & Libraries Used
- R Programming Language
- XGBoost for machine learning
- tidyverse (dplyr, ggplot2, tidyr, purrr) for data processing & visualization
- caret for model tuning
- httr & jsonlite for API requests
- lubridate for time handling

🔍 Key Findings
✅ Humidity has a stronger cooling effect in summer than in winter.  
✅ Dewpoint & wind speed vary significantly across seasons.  
✅ XGBoost outperforms traditional seasonal models but struggles with extreme weather shifts.  
✅ Feature interactions did not significantly improve RMSE, leading to their removal.  
✅ Normalization and Regularization were tested but hurt model accuracy.  

📊 Model Performance
| Forecast Horizon | MAE (°C) | RMSE (°C) |
|-----------------|----------|-----------|
| 7 Days | 2.65 | 3.50 |
| 3 Days | 4.31 | 5.05 |

🔹 7-day forecasts showed reasonable accuracy, but errors increased beyond 3 days.  
🔹 Humidity predictions were the most challenging, requiring further refinement.  

📌 Future Improvements
- Integrate more external factors like wind gusts and cloud cover.  
- Try hybrid models (e.g., combining XGBoost with statistical methods).  
- Experiment with deep learning (CNNs or LSTMs) for long-term forecasting.  

### Additional Considerations
- **Feature Engineering:** Time-series transformations, lag features, and interactions were tested extensively.  
- **Challenges Faced:** High variability in humidity prediction, limited impact of feature interactions.  
- **Next Steps:** Investigate different machine learning models and experiment with alternative tuning techniques for improved forecasting stability.  

This project is a work in progress, and contributions or feedback are welcome!

