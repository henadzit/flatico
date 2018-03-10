# -*- coding: utf-8 -*-
import scrapy
import json

from onliner.items import OnlinerItem

from ipdb import set_trace as st


class RealtSpider(scrapy.Spider):
    name = "onliner.realt"
    allowed_domains = ["pk.api.onliner.by"]

    start_urls = ['https://pk.api.onliner.by/search/apartments?bounds%5Blb%5D%5Blat%5D=53.650335967826045&bounds%5Blb%5D%5Blong%5D=27.33123779296875&bounds%5Brt%5D%5Blat%5D=54.14433895052212&bounds%5Brt%5D%5Blong%5D=27.793350219726566&page={}'.format(page) for page in range(1, 42)]

    def parse(self, response):
        response_data = json.loads(response.body)
        for apartment in response_data['apartments']:
            yield OnlinerItem(apartment)
