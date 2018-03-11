from aiohttp import web

### Request format:
# photo_0: picture of an apartment
# rooms_count
# floor
# has_balcony
# total_square

async def handle_predict(request):
    # data = await request.post()
    return web.Response(text={ 'predicted_price': { 'value': 542345, 'currency': 'USD' }})

app = web.Application()
app.router.add_get('/v1/predict-price', handle_predict)

web.run_app(app, port=80)
