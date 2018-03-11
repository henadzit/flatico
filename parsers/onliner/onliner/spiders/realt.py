# -*- coding: utf-8 -*-
import scrapy
import json
import re

from onliner.items import OnlinerItem


class RealtSpider(scrapy.Spider):
    APARTMENT_URL_PATTERN = 'https://r.onliner.by/pk/apartments/{}'
    IMG_SRC_REGEX = re.compile('\((.+)\)')

    name = "onliner.realt"
    allowed_domains = ["pk.api.onliner.by", "r.onliner.by"]

    start_urls = ['https://pk.api.onliner.by/search/apartments?bounds%5Blb%5D%5Blat%5D=53.650335967826045&bounds%5Blb%5D%5Blong%5D=27.33123779296875&bounds%5Brt%5D%5Blat%5D=54.14433895052212&bounds%5Brt%5D%5Blong%5D=27.793350219726566&page={}'.format(page) for page in range(1, 43)]

    def __init__(self):
        super(RealtSpider, self).__init__()

        self._item_ids = set([])

    def parse(self, response):
        response_data = json.loads(response.body)
        for apartment in response_data['apartments']:
            if apartment['id'] in self._item_ids:
                continue

            self._item_ids.add(apartment['id'])

            item = OnlinerItem(apartment)

            yield scrapy.Request(self.APARTMENT_URL_PATTERN.format(item['id']),
                                 callback=self.parse_images,
                                 meta={'item': item})

    def parse_images(self, response):
        item = response.meta['item']

        style_attrs = response.css('.apartment-cover__thumbnails .apartment-cover__thumbnail::attr(style)')

        imgs = [self.IMG_SRC_REGEX.findall(a.extract()) for a in style_attrs]
        imgs = [i[0] for i in imgs]

        item['image_urls'] = imgs
        yield item
