from lxml import html
import requests
import re
from dateutil.parser import parse
from datetime import datetime
from lxml.html.soupparser import fromstring
from lxml import etree
from BeautifulSoup import BeautifulSoup, NavigableString
import scraperTest

#takes index page on wesleyan film series site and returns list of html extensions for dates
def indexsearch():
	indexpage = requests.get('http://www.wesleyan.edu/filmseries/index.html')
	indextree = html.fromstring(indexpage.content)

	linklist = indextree.xpath('//a/@href')


	regex = re.compile('([a-zA-Z]*)\s([0-9]*)\s([0-9]*)')

	filteredlinks = filter(regex.match, linklist)

	reducedlinks = list(set(filteredlinks))

	return reducedlinks


def strip_tags(html, invalid_tags):
    soup = BeautifulSoup(html)

    for tag in soup.findAll(True):
        if tag.name in invalid_tags:
            s = ""

            for c in tag.contents:
                if not isinstance(c, NavigableString):
                    c = strip_tags(unicode(c), invalid_tags)
                s += unicode(c)

            tag.replaceWith(s)

    return soup

#takes an extension and returns a list of triples (date, movie, description)
def pagesearch(extension):
	page = requests.get('http://www.wesleyan.edu/filmseries/' + extension)
	"""
	body = fromstring(page.content).find('.//description')
	return body.text"""

	pagetree = html.fromstring(page.content)

	# thing = strip_tags(page.content, ['b'])
	soup = BeautifulSoup(page.content)
	# print soup
	# for i in soup.findAll('div', {'class':"movie"}):
	# 	print i.find('p').getText(separator=u' ')

	descriptionlist = [str(i.find('p').getText(separator=u' ')) for i in soup.findAll('div', {'class':"movie"})]
	# return [des.getText() for des in x]
	# for des in x:
	# 	if des != None:
	# 		try:
	# 			print des.getText()
	# 		except:
	# 			pass

	# pagetree = html.fromstring(thing.content)
	#return thing.xpath('//*[@class="indent"]/description/p[1]//text()')


	datelist = pagetree.xpath('//*[@class="movie"]/text()')
	titlelist = pagetree.xpath('//*[@class="movietitle"]/text()')
	infolist = pagetree.xpath('//*[@class = "indent"]/text()')
	# # descriptionlist = pagetree.xpath('//*[@class="indent"]/description/p[1]//text()')
	# #return thing
	# #scraperTest.getHtml(thing) 
	return zip(datelist,titlelist,infolist,descriptionlist)
	# # return descriptionlist
	# return type(descriptionlist[0])
