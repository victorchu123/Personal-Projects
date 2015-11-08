import sqlite3
import datetime
import manmade
import app
from dateutil.parser import parse

def insert_post(movieList):
	#need to connect to database first
	conn = sqlite3.connect('blog.db')

	#creates cursor object
	c = conn.cursor()

	#for every movie in the provided list, pushes all elements of the quadruple into the database
	for movie in (movieList):
		movie_date = movie[0]
		title = movie[1]
		info = movie[2]
		description = movie[3]

		entry = app.Entry.update(
	                title= title,
	                content= description,
	                published= (datetime.datetime.now() > parse(movie_date + ' 8:00PM')) or False,
	                info = info,
	                date = parse(movie_date).date())

#runs insert_post on every quadruple in indexsearch/every week in a month
def getAllInfo():
	for i in range(len(manmade.indexsearch())):
		insert_post(manmade.pagesearch(manmade.indexsearch()[i]))

# test function: getAllInfo()