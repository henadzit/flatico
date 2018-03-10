# -*- coding: utf-8 -*-

import scrapy

class OnlinerItem(scrapy.Item):
    id = scrapy.Field()
    author_id = scrapy.Field()
    created_at = scrapy.Field()
    last_time_up = scrapy.Field()
    area = scrapy.Field()
    area = scrapy.Field()
    auction_bid = scrapy.Field()
    floor = scrapy.Field()
    location = scrapy.Field()
    number_of_floors = scrapy.Field()
    number_of_rooms = scrapy.Field()
    photo = scrapy.Field()
    price = scrapy.Field()
    seller = scrapy.Field()
    url = scrapy.Field()

    resale = scrapy.Field()
    up_available_in = scrapy.Field()

    image_urls = scrapy.Field()
