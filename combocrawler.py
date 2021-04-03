# crawls and downloads multiple anonfiles user:pass combo files
from googlesearch import search
from bs4 import BeautifulSoup
import requests
import sys
import os
if sys.version_info >= (3, 0): #Python 3
    import urllib.request as request
else:
    import urllib as request
import urllib
import time

SEARCHFOR = "\"combo\" site:anonfile.com"
DOWNLOADED = "downloaded.log"
DOWNPATH = "downloads"

done = []
#scrape anonfile and downloads
try:
	f = open(DOWNLOADED,"r")
	done = f.readlines()
	f.close()
except:
	pass

f = open(DOWNLOADED,"a+")
query = search(SEARCHFOR)

i = 0
for url in query:
    time.sleep(10)
    dest = url.split("/")[-1]
    if not dest+"\n" in done:
        try:
            r = requests.get(url)
            html = BeautifulSoup(r.text,"html5lib")
            down = html.find(id="download-url")
            down = down.get("href")
            print("downloading: {}".format(down))
            request.urlretrieve(down,os.path.join(DOWNPATH,str(i)+dest))
            f.write(dest+"\n")
            i+=1
            f.flush()
        except Exception as e:
            print("Error in {}:{}".format(url,e))

f.close()
