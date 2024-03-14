## pip3 install requests
## pip3 install lxml
## pip3 install bs4
## pip3 install Scrapy
## pip3 install selenium
## pip3 install webdriver-manager




import requests
from lxml import html

url = 'https://www.wikipedia.org/'

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
}

respuesta = requests.get(url, headers=headers)
parser = html.fromstring(respuesta.text)
value = parser.get_element_by_id('js-link-box-en')
value_by_xpath = parser.xpath("//a[@id='js-link-box-en']/strong/text()")

idiomas = parser.xpath("//div[contains(@class, 'central-featured-lang')]//strong/text()")
print(value.text_content())
print(idiomas)

for idioma in idiomas:
    print(idioma)

idiomas = parser.find_class('central-featured-lang')

for idioma in idiomas:
    print(idioma.text_content())