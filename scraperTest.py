import requests

'''files = {'f': ('filmseries.pdf', open('filmseries.pdf', 'rb'))}
#response = requests.post("https://pdftables.com/api?key=q9wme1gman1r&format=excel", files=files)
response = requests.post("https://iasext.wesleyan.edu/regprod/!wesmaps_page.html")
response.raise_for_status() # ensure we notice bad responses'''


def getHtml(html): 

	html_file = open("templates/fs_pg.html", "w")


	#creates a html file from the content from the url
	for item in html:
		html_file.write("%s\n" %item)
