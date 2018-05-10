from nltk.tokenize import RegexpTokenizer
from stop_words import get_stop_words
from nltk.stem.porter import PorterStemmer
import sys
import csv
from sklearn.cluster import KMeans
from sklearn.feature_extraction.text import TfidfVectorizer
import nltk
import re
import numpy as np
import pandas as pd

def tokenize_and_stem(text):
    stemmer = PorterStemmer()
    # first tokenize by sentence, then by word
    tokens = [word for sent in nltk.sent_tokenize(text) for word in nltk.word_tokenize(sent)]
    filtered_tokens = []
    # filter out any tokens not containing letters
    for token in tokens:
        if re.search('[a-zA-Z]', token):
            filtered_tokens.append(token)
    stems = [stemmer.stem(t) for t in filtered_tokens]
    return stems

def main():
    tokenizer = RegexpTokenizer(r'\w+')
    # create English stop words list
    en_stop = get_stop_words('en')
    # create p_stemmer of class PorterStemmer
    p_stemmer = PorterStemmer()

    # tf-idf vectorizer from nltk
    tfidf_vectorizer = TfidfVectorizer(stop_words='english',
                                 use_idf=True,
                                 tokenizer=tokenize_and_stem, ngram_range=(1,3))

    # compile sample documents into a list
    doc_set = []
    ids = []

    csv_file1 = open(sys.argv[1], 'r')
    reader = csv.reader(csv_file1)
    for row in reader:
        doc = str(row[2])
        i_d = str(row[0])
        doc_set.append(doc)
        ids.append(i_d)
    csv_file1.close()

    # list for tokenized documents in loop
    texts = []

    # loop through document list
    for i in doc_set:
        # clean and tokenize document string
        raw = i.lower()
        tokens = tokenizer.tokenize(raw)
        # remove stop words from tokens
        stopped_tokens = [i for i in tokens if not i in en_stop]
        # stem tokens
        stemmed_tokens = [p_stemmer.stem(i) for i in stopped_tokens]
        # add tokens to list
        texts.append(stemmed_tokens)

    # tf-idf matrix for the terms in the corpus
    tfidf_matrix = tfidf_vectorizer.fit_transform(doc_set)
    terms = tfidf_vectorizer.get_feature_names()

    # number of clusters
    num_clusters = 8
    seed = 7

    # fitting the k-means algorithm and saving it in a .pkl file
    km = KMeans(n_clusters=num_clusters, random_state=seed)
    km.fit(tfidf_matrix)
    clusters = km.labels_.tolist()

    # data frame that saves the chapter, the text, and the assigned cluster
    cluster_df = {'ID': ids, 'Cluster': clusters}
    frame = pd.DataFrame(cluster_df, columns = ['ID', 'Cluster'])

    frame.to_csv('Article-Clustering.csv', encoding='utf-8')

main()
