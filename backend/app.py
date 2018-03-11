from aiohttp import web
import io

from classifier import Classifier

from catboost import CatBoostRegressor

import tempfile

### Request format:
# photo_0: picture of an apartment
# rooms_count
# floor
# has_balcony
# total_square
# latitude
# longitude


image_classifier = Classifier()
model = CatBoostRegressor().load_model("fitted_model")


CLASS_TO_APT_STATE = {
    'netotd': 1,
    'bab': 2,
    'remont': 3
}


async def handle_predict(request):
    data = await request.post()
    model_input_params = {
        'rooms_count': int(data.get('rooms_count', None)),
        'floor': int(data.get('floor', None)),
        'has_balcony': bool(data.get('has_balcony', None)),
        'total_square': float(data.get('total_square', None)),
        'latitude': float(data.get('latitude', None)),
        'longitude': float(data.get('longitude', None)),
    }

    buffer = data.get('photo_0').file
    uploaded_file_reader = io.BufferedReader(buffer)

    with tempfile.NamedTemporaryFile(mode="wb", delete=True) as img:
        img.write(uploaded_file_reader.read())
        img.seek(0, 0)

        classification_res = image_classifier.classify(img.name)[0]
        model_input_params['apt_state'] = CLASS_TO_APT_STATE[classification_res[0]]

    print(model_input_params)

    # TODO: 10 is the hardcoded number of floors
    price = model.predict([[model_input_params['floor'],
                            10,
                            model_input_params['total_square'],
                            model_input_params['latitude'],
                            model_input_params['longitude'],
                            model_input_params['apt_state']]])[0]

    # import pdb; pdb.set_trace()

    response_data = { 'predicted_price': { 'value': price, 'currency': 'USD' }, 'input_params': model_input_params }
    return web.json_response(response_data)

app = web.Application(client_max_size=10_000_000)
app.router.add_post('/v1/predict-price', handle_predict)

web.run_app(app, port=8080)
