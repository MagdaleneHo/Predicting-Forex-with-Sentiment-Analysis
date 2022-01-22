library("sentimentr")
library("tidytext")
library("rvest")
library("tidyverse")
library("lexicon")
library("dplyr")
library("textdata")
library("ggplot2")

# read csv
guardian_raw <- read_csv("Guardian.csv")
exchange <- read_csv("EUR-USD.csv")
exchange2 <- read_csv("GBP-USD.csv")

########################################### Sentence-based ###########################################

# sentence sentiment score by date (a function by sentimentr package)
GuardianSS <- with(guardian_raw, sentiment_by(Headline, list(Date))) %>%
  # create a binary category based on the sentiment score where '1' is positive and '0' is negative
  mutate(binary_category = case_when(ave_sentiment > 0 ~ "1", 
                                        ave_sentiment < 0 ~ "0"))  
# change to data frame 
df <- data.frame(GuardianSS) 
final_GuardianSS <- subset(df, select = c(Date, ave_sentiment, binary_category))

# merging with EUR-USD dataset
GSS_Ex <- left_join(final_GuardianSS, exchange, by=c("Date")) %>% 
  drop_na()
#write.csv(GSS_Ex, file = "GuardianSS.csv")

# merging with GBP-USD dataset
GSS_Ex2 <- left_join(final_GuardianSS, exchange2, by=c("Date")) %>% 
  drop_na()
#write.csv(GSS_Ex2, file = "GuardianSS2.csv")
########################################### Word-based ###############################################
# create an ID
gt <- tibble::rowid_to_column(guardian_raw, "ID")

# using sentiwordnet package
sentiword_g <- hash_sentiment_sentiword
names(sentiword_g) <- c("word","score")

# tokenize the headlines 
iliad_g <- gt %>% 
  tibble(text = Headline) %>%
  unnest_tokens(word, text) 

# create sentiments based on each of the lexicons
sentiword_sentiment_guardian <- iliad_g %>% 
  inner_join(sentiword_g, by = "word") %>%
  group_by(ID) %>% 
  # summing the score for the sentence
  mutate(sum_score = sum(score)) %>%
  distinct_at(vars(ID), .keep_all = TRUE) 

# average the score for a day
GuardianWS <- sentiword_sentiment_guardian %>% 
  group_by(Date) %>% 
  mutate(ave_score = mean(sum_score)) %>% 
  mutate(binary_category = case_when(ave_score > 0 ~ "1",
                                        ave_score < 0 ~ "0")) %>% 
  distinct_at(vars(Date), .keep_all = TRUE) 

df <- data.frame(GuardianWS) 
final_GuardianWS <- subset(df, select = c(Date, ave_score, binary_category))

# merging with EUR-USD dataset
GWS_Ex <- left_join(final_GuardianWS, exchange, by=c("Date")) %>% 
  drop_na()
#write.csv(GWS_Ex, file = "GuardianWS.csv")

# merging with GBP-USD dataset
GWS_Ex2 <- left_join(final_GuardianWS, exchange2, by=c("Date")) %>% 
  drop_na()
#write.csv(GWS_Ex2, file = "GuardianWS2.csv")

########################################### Emotion Category #########################################

nrc_joy <- get_sentiments("nrc")

gcat <- guardian_raw %>% 
  tibble(text = Headline) %>%
  unnest_tokens(word, text)%>%
  inner_join(nrc_joy) %>%
  count(sentiment, sort = TRUE) %>% 
  mutate(percentage = n/sum(n)) %>% 
  mutate(source = "Guardian")

guardian_plot <- ggplot(gcat, aes(x = sentiment, y = n, fill = n)) +
  geom_col() +
  xlab("sentiment category") +
  ylab("count") +
  ggtitle("Guardian Headlines") + 
  labs(fill = "Count") +
  theme(plot.title = element_text(size=14, hjust = 0.5)) 

guardian_plot

#combine
G1 <- subset(final_GuardianSS, select = c(binary_category)) %>% 
  mutate(sentiment_type = "sentence") %>% 
  mutate(category = case_when(binary_category == 1 ~ "positive",
                              binary_category == 0 ~ "negative"))%>%
  count(category, sort = TRUE) %>% 
  mutate(source = "Guardian") %>% 
  mutate(sentiment_type = "sentence") %>% 
  mutate(percentage = n/sum(n)) %>% 
  drop_na()

G2 <- subset(final_GuardianWS, select = c(binary_category)) %>% 
  mutate(sentiment_type = "word")%>% 
  mutate(category = case_when(binary_category == 1 ~ "positive",
                              binary_category == 0 ~ "negative"))%>%
  count(category, sort = TRUE)%>% 
  mutate(source = "Guardian") %>% 
  mutate(sentiment_type = "word") %>% 
  mutate(percentage = n/sum(n)) %>% 
  drop_na()

########################################### Comparison ##############################################

#comparison of the news sources (emotion categories)
cat <- rbind(gcat,rcat,ccat,mcat) %>% 
  mutate(percentage = round(percentage * 100, 2))

comparison_line <- ggplot(cat, aes(x = sentiment, y = percentage, color=source, group = source )) +
  geom_line() +
  geom_point() +
  xlab("sentiment category") +
  ylab("percentage") +
  ggtitle("Comparison of the Percentage \n of Each Sentiment Category with \n Different News Source") + 
  theme(plot.title = element_text(size=14, hjust = 0.5)) 
comparison_line



#comparison of the positive and negative emotions
scomb <- rbind(G1,R1,M1,C1) %>% 
  mutate(percentage = round(percentage * 100, 2))
wcommb <- rbind(G2,R2,M2,C2) %>% 
  mutate(percentage = round(percentage * 100, 2))

comparison_sentence <- ggplot(scomb, aes(fill=source, y= percentage, x=category)) + 
  geom_bar(position="dodge", stat="identity") + 
  geom_text(aes(label=percentage), position=position_dodge(width=0.9), vjust=-0.25)+
  xlab("sentiment category") +
  ylab("percentage") +
  ggtitle("Positive and Negative Sentiment (Sentence-based) with Different News Source") + 
  theme(plot.title = element_text(size=14, hjust = 0.5)) 
comparison_sentence

comparison_word <- ggplot(wcommb, aes(fill=source, y= percentage, x=category)) + 
  geom_bar(position="dodge", stat="identity") + 
  geom_text(aes(label=percentage), position=position_dodge(width=0.9), vjust=-0.25)+
  xlab("sentiment category") +
  ylab("percentage") +
  ggtitle("Positive and Negative Sentiment (Word-based) with Different News Source") + 
  theme(plot.title = element_text(size=14, hjust = 0.5)) 
comparison_word