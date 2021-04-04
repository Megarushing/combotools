# crawls and downloads multiple anonfiles user:pass combo files
from googlesearch import search
from bs4 import BeautifulSoup
import requests
import sys
import os
from pyunpack import Archive
from shutil import copyfile
if sys.version_info >= (3, 0): #Python 3
    import urllib.request as request
else:
    import urllib as request
import urllib
import time

SEARCHFOR = ["\"combo\" site:anonfile.com","\"Combo\" site:anonfile.com"]
DOWNLOADED = "downloaded.log"
DOWNPATH = "downloads"
DESTPATH = "inputbreach"

def extract(path):
	try:
		if path.lower().endswith(".txt"):
			copyfile(path,os.path.join(DESTPATH,os.path.basename(path)))
		else:
			Archive(path).extractall(DESTPATH)
	except Exception as e:
		print("Error extracting {}:{}".format(path,e))

done = []
#scrape anonfile and downloads
try:
	f = open(DOWNLOADED,"r")
	done = f.readlines()
	f.close()
except:
	pass

f = open(DOWNLOADED,"a+")
for s in SEARCHFOR:
	query = search(s)
	i = 0
	for url in query:
	    dest = url.split("/")[-1]
	    if not dest+"\n" in done:
	        try:
	            r = requests.get(url)
	            html = BeautifulSoup(r.text,"html.parser")
	            down = html.find(id="download-url")
	            down = down.get("href")
	            print("downloading: {}".format(down))
	            path = os.path.join(DOWNPATH,str(i)+dest)
	            request.urlretrieve(down,path)
	            extract(path)
	            os.remove(path)
	            f.write(dest+"\n")
	            i+=1
	            f.flush()
	        except Exception as e:
	            print("Error in {}:{}".format(url,e))
	    time.sleep(0) # avoids google ban

f.close()
