import sqlite3
import datetime
import manmade
import app

def insert_post(movieList):
	#need to connect to database first
	conn = sqlite3.connect('blog.db')

	#creates cursor object
	c = conn.cursor()

	#
	for movie in (movieList):
		movie_date = movie[0]
		title = movie[1]
		info = movie[2]
		description = movie[3]

		entry = app.Entry.create(
	                title= title,
	                content= description,
	                published= if (datetime.now() > parse(movie_date + ' 8:00PM')) or False,
	                info = info,
	                date = movie_date)

insert_post(manmade.pagesearch(manmade.indexsearch()[0]))