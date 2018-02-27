from nltk.tokenize import RegexpTokenizer
from stop_words import get_stop_words
from nltk.stem.porter import PorterStemmer
from gensim import corpora, models
import gensim
import sys
from itertools import chain
import csv
from sklearn.cluster import KMeans

def main():
    tokenizer = RegexpTokenizer(r'\w+')
    # create English stop words list
    en_stop = get_stop_words('en')
    # create p_stemmer of class PorterStemmer
    p_stemmer = PorterStemmer()
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

    # turn our tokenized documents into a id <-> term dictionary
    dictionary = corpora.Dictionary(texts)
    # convert tokenized documents into a document-term matrix
    corpus = [dictionary.doc2bow(text) for text in texts]
    num_topics=15
    # generate LDA model
    ldamodel = gensim.models.ldamodel.LdaModel(corpus, num_topics=num_topics, id2word = dictionary, minimum_probability=0, passes=100)
    # print(ldamodel.print_topics(num_topics=8, num_words=3))
    # Assigns the topics to the documents in corpus
    # ****Uncomment from here******`

    lda_corpus = ldamodel[corpus]
    # Find the threshold, let's set the threshold to be 1/#clusters,
    # To prove that the threshold is sane, we average the sum of all probabilities:
    scores = list(chain(*[[score for topic_id,score in topic] \
                          for topic in [doc for doc in lda_corpus]]))
    threshold = sum(scores)/len(scores)
    print (threshold)
    print()

    cluster1 = [j for i,j in zip(lda_corpus,ids) if i[0][1] > threshold]
    cluster2 = [j for i,j in zip(lda_corpus,ids) if i[1][1] > threshold]
    cluster3 = [j for i,j in zip(lda_corpus,ids) if i[2][1] > threshold]
    cluster4 = [j for i,j in zip(lda_corpus,ids) if i[3][1] > threshold]

    # print(len(cluster1))
    # print(len(cluster2))
    # print(len(cluster3))
    # print(len(cluster4))
    print(cluster1)




main()
