from lxml import html
import requests

homepage = requests.get('http://www.wesleyan.edu/filmseries/index.html')
hometree = html.fromstring(homepage.content)

links = hometree.xpath('//*[@id="content_primary"]/p[3]/a[1]').get("href")

print links