from catboost import CatBoostRegressor

model = CatBoostRegressor().load_model("zaebis_model")

# floor_number, total_floors, area, latitude, longitude

model.predict([[2, 5, 45, 53.908681, 27.572759]])
