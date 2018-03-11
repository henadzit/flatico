from aiohttp import web

### Request format:
# photo_0: picture of an apartment
# rooms_count
# floor
# has_balcony
# total_square

async def handle_predict(request):
    # data = await request.post()
    response_data = { 'predicted_price': { 'value': 542345, 'currency': 'USD' }}
    return web.json_response(response_data)

app = web.Application()
app.router.add_post('/v1/predict-price', handle_predict)

web.run_app(app, port=80)
