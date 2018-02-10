# To run:
# python3 Parser.py [name of .csv file]

from bs4 import BeautifulSoup
import requests
import sys
import csv
import zlib
from lxml import html

def parse(soup, new_rows_list):
    tagList = soup.findAll("div", {"class": "entry__text js-entry-text bn-entry-text yr-entry-text"})

    for tag in tagList:
        if tagCheck(tag) == True:
            text = cleanText(tag);
        new_rows_list.append(str(text)[1:-1]+"\n")

def tagCheck(tag):
    contents = tag.findAll("div", {"class":"content-list-component bn-content-list-text yr-content-list-text text"})
    if contents == None:
        return False
    else:
        return True

def cleanText(tag):
        tagcodeList = tag.findAll("div", {"class":"content-list-component bn-content-list-text yr-content-list-text text"})
        codeList = []
        for code in tagcodeList:
            code = code.get_text(" ",strip=True)
            codeList.append(code)
        return codeList

def main():
    new_rows_list = []
    csv_file1 = open(sys.argv[1], 'r')
    reader = csv.reader(csv_file1)
    for row in reader:
        address = str(row[0])
        print(address)
        html = requests.get(address, stream=True)
        html = html.text
        soup = BeautifulSoup(html, 'html5lib')
        parse(soup, new_rows_list)
    csv_file1.close()

    csv_file2 = open(sys.argv[1], 'w')
    writer = csv.writer(csv_file2)
    writer.writerows(new_rows_list)
    file2.close()

    print('Parsing complete!')

main()
