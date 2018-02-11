# To run:
# python3 Parser.py [name of .csv file]

from bs4 import BeautifulSoup
import requests
import sys
import csv
import zlib
from lxml import html

def parse(soup, url, file):
    tagList = soup.findAll("div", {"class": "entry__text js-entry-text bn-entry-text yr-entry-text"})

    for tag in tagList:
        if tagCheck(tag) == True:
            text = cleanText(tag);
    file.write(url + "," + str(text)[1:-1] + "\n")

def tagCheck(tag):
    contents = tag.findAll("div", {"class":"content-list-component bn-content-list-text yr-content-list-text text"})
    if contents == None:
        return False
    else:
        return True

def cleanText(tag):
        codeList = ""
        for code in tag:
            code = code.get_text(" ",strip=True)
            codeList+=" "+code
        return codeList;

def main():
    csv_file1 = open(sys.argv[1], 'r')
    csv_file2 = open('text-data.csv', 'w', encoding="utf8")
    writer = csv.writer(csv_file2, delimiter=',')
    reader = csv.reader(csv_file1)
    for row in reader:
        url = str(row[0])
        fullText = ""
        headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'}
        html = requests.get(url, headers=headers)
        html = html.content.decode('utf-8', 'ignore')
        soup = BeautifulSoup(html, 'html.parser')
        for chunk in soup.findAll("div", {"class":"content-list-component bn-content-list-text yr-content-list-text text"}):
            chunk = cleanText(chunk);
            fullText+=(chunk);
        writer.writerow([url]+[fullText])
    csv_file1.close()
    csv_file2.close()

    print('Parsing complete!')

main()
