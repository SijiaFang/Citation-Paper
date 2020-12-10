require(igraph)
library(tm)
library(Matrix)  ## sparse matrix computation
library(rARPACK)  ## fast eigenvector computation
library(irlba)   ## fast svd computation
library(xtable) #generate table in latex code
library(data.table)
library(tidyverse)
library(tidytext)
library(Matrix)
require(vsp)
require(SnowballC)
require(wordcloud)
library(wordcloud2)
require(RColorBrewer)
require(RCurl)
require(XML)
library(dplyr)
library(gdata)
library(janeaustenr)

#data reading and cleaning
Paper <-read.table('Paper-v4.txt',header = T,sep = '|',fill = T,encoding='latin1',
                   comment.char = "")
Paper_NA <- Paper
Paper_NA[,2] <- as.numeric(as.character(Paper[,2]))
sum(is.na(Paper_NA))# Get rid of all paper which name is empty.
Paper_NA <- na.omit(Paper_NA)
Paper_NA=Paper_NA[Paper_NA$Id!="",]

rm(Paper)

## data preprocessing

text0=paste (Paper_NA$Title, 
             Paper_NA$Abstract, sep = " ", collapse = NULL, recycle0 = FALSE)
docs <- VCorpus(VectorSource(text0))

# Converting to lowercase:
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, PlainTextDocument)

# remove numbers
docs <- tm_map(docs, removeNumbers)

# remove punctuations
#docs <- tm_map(docs, removePunctuation)

# Removing common word endings (e.g., "ing", "es", "s")
docs <- tm_map(docs, stemDocument) 

# Remove the common English words
docs <- tm_map(docs, removeWords, stopwords("english"))

# Change it to character form
text3= lapply(docs, as.character)

#rm(Paper_NA)
rm(docs)

#tokenize
text_df <- tibble(tweet = Paper_NA$Title, text =text3)
tt  = text_df %>% unnest_tokens(word, text)
str(tt)
tt=filter(tt,nchar(word)>2)

A = cast_sparse(tt, tweet, word)
papername=rownames(A)
# grouping when ngroup =100
ngroup=100
fa = vsp(A, rank = ngroup) 
rownames(fa$Z)<-papername

plot_varimax_z_pairs(fa, 1:ngroup)

# word cloud
#text_df1 <- tibble(tweet = Paper_NA$Id, 
#                   text =paste (Paper_NA$Title, 
#                                Paper_NA$Abstract, sep = " ", collapse = NULL,
#                                recycle0 = FALSE),S=S)
#words1  = text_df1 %>% 
#  unnest_tokens(word, text) %>% 
#  count(S,word, sort=TRUE)

#words1 %>%
#  bind_tf_idf(word,S,n) %>%
#  arrange(desc(tf_idf))

#for(i in 1:ngroup){
#  words2  = text_df1[text_df1$S==i,] %>% 
#    unnest_tokens(word, text)
#  got_counts <- words2 %>%
#    anti_join(stop_words, by = c("word" = "word")) %>%
#    count(word,sort = TRUE)
  
#  wordcloud2(data=got_counts)
#  got_counts
#}

# bff is the "best feature function"
keywords = bff(fa$Z, A,20)
keywords %>% t %>% View