# Reference: https://pypi.python.org/pypi/textstat

from gensim.summarization import summarize
from gensim.summarization import keywords
from textstat.textstat import textstat
import sys
import csv

def main():
    csv_file1 = open(sys.argv[1], 'r')
    csv_file2 = open('text-stats.csv', 'w')
    reader = csv.reader(csv_file1)
    writer = csv.writer(csv_file2, delimiter=',')
    doc_id = 1
    writer.writerow(["ID", "URL", "text", "readability", "grade-level", "smog-index", "total-words", "total-sentences", "keywords", "summary"])
    for row in reader:
        url = str(row[0])
        text = str(row[1])
        read_ease = textstat.flesch_reading_ease(text)
        grade = textstat.flesch_kincaid_grade(text)
        smog = textstat.smog_index(text)
        words = textstat.lexicon_count(text)
        sentences = textstat.sentence_count(text)
        summary = summarize(text, ratio=0.3)
        key_words = keywords(text, ratio=0.3)

        writer.writerow([doc_id]+[url]+[text]+[read_ease]+[grade]+[smog]+[words]+[words]+[key_words]+[summary])
        doc_id = doc_id+1
    csv_file1.close()
    csv_file2.close()

    print('Summary statistics complete!')

main()
