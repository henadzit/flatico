from catboost import CatBoostRegressor

model = CatBoostRegressor().load_model("fitted_model")

# floor_number, total_floors, area, latitude, longitude, apt_state

model.predict([[2, 5, 45, 53.908681, 27.572759, 1]])
