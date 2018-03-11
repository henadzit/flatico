from aiohttp import web
import io

from classifier import Classifier

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
        model_input_params['apt_state'] = classification_res[0]

    print(model_input_params)
    
    response_data = { 'predicted_price': { 'value': 542345, 'currency': 'USD' }, 'input_params': model_input_params }
    return web.json_response(response_data)

app = web.Application()
app.router.add_post('/v1/predict-price', handle_predict)

web.run_app(app, port=8080)
