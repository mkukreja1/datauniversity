import urllib2
response = urllib2.urlopen('https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22')
html = response.read()
print(html) 
