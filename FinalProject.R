library(tidytext)
library(tidyverse)
library(readtext)
library(tm)
library(topicmodels)
library(ggplot2)
library(widyr)

# Load zip file of Daily Occurrence Docket entries in txt.files
download.file("https://github.com/jessfoster/8510-Final-Project/blob/main/DOD_Texts.zip?raw=true", "DOD_Texts.zip")
unzip("DOD_Texts.zip")

# Metadata that includes info about each text
metadata <- read.csv("https://raw.githubusercontent.com/jessfoster/8510-Final-Project/main/DOD_Metadata.csv")

meta <- as.data.frame(metadata)
file_paths <- list.files("DOD_Texts/")
dod_texts <- readtext(paste("DOD_Texts/", file_paths, sep=""))
dod_whole <- full_join(meta, dod_texts, by = c("filename" = "doc_id")) %>% as_tibble()

tidy_dod <- dod_whole %>%
  unnest_tokens(word, text) %>% 
  filter(str_detect(word, "[a-z']$"))

stop_words_dod <- tibble(
  word = c(
    "admitted",
    "discharged",
    "died",
    "lived",
    "age",
    "legal",
    "resident",
    "residence",
    "city",
    "born",
    "credit",
    "debit",
    "instant",
    "last",
    "ago",
    "hath",
    "ultimo",
    "southwark",
    "northern",
    "liberties",
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
    "philadelphia",
    "james",
    "collings",
    "isaac",
    "tatem",
    "hopper",
    "john",
    "william",
    "thomas",
    "hockley",
    "elizabeth",
    "mary"
  ),
  lexicon = "DOD"
)

all_stop_words <- stop_words %>%
  bind_rows(stop_words_dod)

tidy_dod <- tidy_dod %>%
  anti_join(all_stop_words)

tidy_dod %>%
  count(word, sort = TRUE)

# dod_bigrams <- dod_whole %>%
#   unnest_tokens(bigram, text, token = "ngrams", n = 2)
# 
# head(dod_bigrams$bigram)

tidy_dod_words <- tidy_dod %>% count(filename, word)

dod.dtm <- tidy_dod_words %>% 
  count(filename, word) %>% 
  cast_dtm(filename, word, n)

dod.lda <- LDA(dod.dtm, k = 5, control = list(seed = 12345))
dod.lda

dod.topics <- tidy(dod.lda, matrix = "beta")
dod.topics

dod.top.terms <- dod.topics %>%
  group_by(topic) %>%
  top_n(5, beta)

dod.top.terms %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

library(wordcloud)

topic1 <- dod.topics %>%
  filter(topic == 1)

topic2 <- dod.topics %>% 
  filter(topic == 2)

topic3 <- dod.topics %>%
  filter(topic == 3)

topic4 <- dod.topics %>%
  filter(topic == 4)

wordcloud(topic1$term, topic1$beta, max.words = 50, random.order = FALSE,
          rot.per = 0.3, colors = brewer.pal(6, "Dark2"))

wordcloud(topic2$term, topic2$beta, max.words = 50, random.order = FALSE,
          rot.per = 0.3, colors = brewer.pal(6, "Dark2"))

wordcloud(topic3$term, topic3$beta, max.words = 50, random.order = FALSE,
          rot.per = 0.3, colors = brewer.pal(6, "Dark2"))

wordcloud(topic4$term, topic4$beta, max.words = 100, random.order = FALSE,
          rot.per = 0.3, colors = brewer.pal(6, "Dark2"))

dod.tf.idf <- tidy_dod %>%
  count(filename, word, sort = TRUE) %>% # Count how many times each word appears in each document
  bind_tf_idf(word, filename, n) # Calculate term frequency based on inverse document frequency

head(dod.tf.idf)

dod.tf.idf %>% arrange(desc(tf_idf))

dod_word_pairs <- dod_whole %>%
  unnest_tokens(word, text) %>%   # tokenize
  filter(!word %in% all_stop_words$word) %>%  # remove stopwords
  pairwise_count(word, filename, sort = TRUE, upper = FALSE) # don't include upper triangle of matrix

library(igraph)
library(ggraph)

dod_word_pairs %>% 
  filter(n >= 40) %>%  # only word pairs that occur 50 or more times
  graph_from_data_frame() %>% #convert to graph
  ggraph(layout = "fr") + # place nodes according to the force-directed algorithm of Fruchterman and Reingold
  geom_edge_link(aes(edge_alpha = n, edge_width = n), edge_colour = "tomato") +
  geom_node_point(size = 5) +
  geom_node_text(aes(label = name), repel = TRUE, 
                 point.padding = unit(0.2, "lines")) +
  theme_void()

