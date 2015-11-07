from lxml import html
import requests
import re

#takes index page on wesleyan film series site and returns list of html extensions for dates
def indexsearch():
	indexpage = requests.get('http://www.wesleyan.edu/filmseries/index.html')
	indextree = html.fromstring(indexpage.content)

	linklist = indextree.xpath('//a/@href')


	regex = re.compile('([a-zA-Z]*)\s([0-9]*)\s([0-9]*)')

	filteredlinks = filter(regex.match, linklist)

	reducedlinks = list(set(filteredlinks))

	return reducedlinks


#takes an extension and returns a list of triples (date, movie, description)
def pagesearch(extension):
	page = requests.get('http://www.wesleyan.edu/filmseries/' + extension)
	pagetree = html.fromstring(page.content)

	datelist = pagetree.xpath('//*[@class="movie"]/text()')
	titlelist = pagetree.xpath('//*[@class="movietitle"]/text()')
	infolist = pagetree.xpath('//*[@class = "indent"]/text()')
	descriptionlist = pagetree.xpath('//*[@class="indent"]/description/p/text()')
	return zip(datelist,titlelist,infolist,descriptionlist)
