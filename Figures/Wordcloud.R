#Dataframe for the keywords
Keywords <- read_csv2(here("Figures/Research", "Fabio-Articles.csv"))

keywords <- Keywords %>% select(Abstract)  #%>% as.tibble() 
keywords = distinct(keywords, .keep_all = TRUE)

# Preparing
revision.texto=paste(keywords$Abstract, collapse=" ")
revision.texto=strsplit(revision.texto, c("\\, |\\; |\\-"))  

# Corpus
corpus.text <- Corpus(VectorSource(revision.texto)) 
#Cleaning data
corpus.text=tm_map(corpus.text, content_transformer(tolower))    # Tranforming data lower case
corpus.text = tm_map(corpus.text, removePunctuation)               # Removing puntuaction
corpus.text=tm_map(corpus.text, stripWhitespace) # Removing spaces 
corpus.text = tm_map(corpus.text, removeWords, stopwords("english")) # Remove english common stopwords
corpus.text <- tm_map(corpus.text, removeWords, c("blabla1", "blabla2")) # specify your stopwords as a character vector


dtm <- TermDocumentMatrix(corpus.text)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
#head(d, 10)
rm(dtm, m, v, corpus.text, revision.texto)




#ggwordcloud(words = d$word, freq = d$freq,  colors=brewer.pal(8, "Dark2"))
#wordcloud(words = d$word, freq = d$freq, min.freq = 1, scale=c(2.5,.4),
#  max.words=200, random.order=FALSE, rot.per=0.35,
# colors=brewer.pal(8, "Dark2"))
cloud <-   wordcloud2(data = d, size = 1, shape = 'circle', minSize = 9) 


library(htmlwidgets)
saveWidget(cloud,"Figures/cloud.html",selfcontained = F)
webshot::webshot("Figures/cloud.html","Figures/Cloud.png",vwidth = 1000, vheight = 800, delay =10)
