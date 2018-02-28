# Reference: https://pypi.python.org/pypi/textstat

from gensim.summarization import summarize
from gensim.summarization import keywords
from textstat.textstat import textstat
import sys
import csv

def main():
    csv_file2 = open(sys.argv[2], 'w', encoding="utf8")
    writer = csv.writer(csv_file2, delimiter=',')
    doc_id = 1
    writer.writerow(["ID", "URL", "text", "impact-score", "readability", "grade-level", "smog-index", "total-words", "total-sentences"])
    with open(sys.argv[1], 'r',  encoding="utf8", errors='ignore') as csv_file1:
        reader = csv.reader(csv_file1)
        # Skip the first line with headers
        next(reader)
        for row in reader:
            impact = str(row[0])
            url = str(row[1])
            text = str(row[2])
            read_ease = textstat.flesch_reading_ease(text)
            grade = textstat.flesch_kincaid_grade(text)
            smog = textstat.smog_index(text)
            words = textstat.lexicon_count(text)
            sentences = textstat.sentence_count(text)
            # Uncomment this if we want summary and key words
            # summary = summarize(text, ratio=0.3)
            # key_words = keywords(text, ratio=0.3)

            writer.writerow([doc_id]+[url]+[text]+[impact]+[read_ease]+[grade]+[smog]+[words]+[sentences])
            doc_id = doc_id+1
    csv_file1.close()
    csv_file2.close()

    print('Summary statistics complete!')

main()
