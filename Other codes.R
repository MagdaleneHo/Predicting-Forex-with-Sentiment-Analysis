#Download R packages
library("dplyr")
library("corrplot")
library("moments")
library("tidyverse")
########################################## Data Understanding #############################################

########################################## Forex Data #############################################
EURUSD <- read_csv("EUR-USD.csv")
str(EURUSD) #data type
summary(EURUSD) #basic summary statistics
head(EURUSD,10) #first 10 obs
sum(is.na(EURUSD)) #total null values

pdf(file = "corrplot.pdf", width = 8.5, height = 11)
corrplot(cor(EURUSD %>% 
               select(Open:Volume)), #Selecting the numeric variables
         method="color",  #the output of plot
         sig.level = 0.01, insig = "blank",
         addCoef.col = "black", 
         tl.srt=45, 
         type="upper" 
)
dev.off()

Open <-EURUSD$Open
High <-EURUSD$High
Low <-EURUSD$Low
Close <-EURUSD$Close
Volume <-EURUSD$Volume

print(skewness(Open))
print(skewness(High))
print(skewness(Low))
print(skewness(Close))
print(skewness(Volume))

pdf(file = "histogram1.pdf", width = 8.5, height = 11)
hist(Open,main="Distribution of the Open value (EUR/USD)",
     xlab = "Open value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram2.pdf", width = 8.5, height = 11)
hist(High,main="Distribution of the High value (EUR/USD)",
     xlab = "High value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram3.pdf", width = 8.5, height = 11)
hist(Low,main="Distribution of the Low value (EUR/USD)",
     xlab = "Low value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram4.pdf", width = 8.5, height = 11)
hist(Close,main="Distribution of the Close value (EUR/USD)",
     xlab = "Close value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram5.pdf", width = 8.5, height = 11)
hist(Volume,main="Distribution of the Volume value (EUR/USD)",
     xlab = "Volume value in 2019-2020",col = "light blue",border = "black")
dev.off()


# GBP/USD

GBPUSD <- read_csv("GBP-USD.csv")
str(GBPUSD) #data type
summary(GBPUSD) #basic summary statistics
head(GBPUSD,10) #first 10 obs
sum(is.na(GBPUSD)) #total null values

pdf(file = "corrplot2.pdf", width = 8.5, height = 11)
corrplot(cor(GBPUSD %>% 
                     select(Open:Volume)), #Selecting the numeric variables
         method="color",  #the output of plot
         sig.level = 0.01, insig = "blank",
         addCoef.col = "black", 
         tl.srt=45, 
         type="upper" 
)
dev.off()

Open2 <-GBPUSD$Open
High2 <-GBPUSD$High
Low2 <-GBPUSD$Low
Close2 <-GBPUSD$Close
Volume2 <-GBPUSD$Volume

print(skewness(Open2))
print(skewness(High2))
print(skewness(Low2))
print(skewness(Close2))
print(skewness(Volume2))

pdf(file = "histogram1_1.pdf", width = 8.5, height = 11)
hist(Open2,main="Distribution of the Open value (GBP/USD)",
     xlab = "Open value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram2_1.pdf", width = 8.5, height = 11)
hist(High2,main="Distribution of the High value  (GBP/USD)",
     xlab = "High value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram3_1.pdf", width = 8.5, height = 11)
hist(Low2,main="Distribution of the Low value (GBP/USD)",
     xlab = "Low value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram4_1.pdf", width = 8.5, height = 11)
hist(Close2,main="Distribution of the Close value (GBP/USD)",
     xlab = "Close value in 2019-2020",col = "light blue",border = "black")
dev.off()

pdf(file = "histogram5_1.pdf", width = 8.5, height = 11)
hist(Volume2,main="Distribution of the Volume value (GBP/USD)",
     xlab = "Volume value in 2019-2020",col = "light blue",border = "black")
dev.off()
########################################## Text Data ##############################################

Reuters <- read_csv("reuters_headlines.csv")
head(Reuters,10) #first 10 obs
sum(is.na(Reuters)) #total null values

CNBC <- read_csv("cnbc_headlines.csv")
head(CNBC,10) #first 10 obs
sum(is.na(CNBC)) #total null values

Guardian <- read_csv("guardian_01_20.csv")
head(Guardian,10) #first 10 obs
sum(is.na(Guardian)) #total null values

nytimes <- read_csv("2019-01.csv")
head(nytimes,10) #first 10 obs
sum(is.na(nytimes)) #total null values

########################################## Data Visualization ################################################

scores <- read_csv("Scores.csv")  

#Algorithm 
algo <- scores %>% 
        group_by(Algorithm) %>% 
        summarize(Avg = mean(Accuracy)) %>% 
        mutate(Avg = round(Avg * 100,2))

algo_plot <- ggplot(algo, aes(x = Algorithm, y = Avg, fill = Algorithm)) +
        geom_bar(position="dodge", stat="identity") +
        geom_text(aes(label=Avg), position=position_dodge(width=0.9), vjust=-0.25)+
        xlab("algorithms") +
        ylab("average accuracy") +
        ggtitle("Average Accuracy of each Algorithm") + 
        labs(fill = "algorithms") +
        theme(plot.title = element_text(size=14, hjust = 0.5)) 
algo_plot

#News source
source <- scores %>% 
        group_by(Source) %>% 
        summarize(Avg = mean(Accuracy)) %>% 
        mutate(Avg = round(Avg * 100,2))

source_plot2 <- ggplot(source, aes(x = Source, y = Avg, fill = Source)) +
        geom_bar(position="dodge", stat="identity") +
        geom_text(aes(label=Avg), position=position_dodge(width=0.9), vjust=-0.25)+
        xlab("news source") +
        ylab("average accuracy") +
        ggtitle("Average Accuracy of each News Source") + 
        theme(plot.title = element_text(size=14, hjust = 0.5)) 
source_plot2

#Algorithm vs Source
salgo <- scores %>% 
        group_by(Algorithm, Source) %>% 
        summarize(Avg = mean(Accuracy)) %>% 
        mutate(Avg = round(Avg * 100,2))

salgo_line <- ggplot(salgo, aes(x = Algorithm, y = Avg, color=Source, group = Source )) +
        geom_line() +
        geom_point() +
        xlab("algorithm") +
        ylab("average accuracy") +
        ggtitle("Average Accuracy of Algorithm compared with News Source") + 
        theme(plot.title = element_text(size=14, hjust = 0.5)) 
salgo_line


# Sentiment type vs Source
ssource <- scores %>% 
        group_by(Sentiment_type, Source) %>% 
        summarize(Avg = mean(Accuracy)) %>% 
        mutate(Avg = round(Avg * 100,2))

ssource_plot2 <- ggplot(ssource, aes(x = Sentiment_type, y = Avg, fill = Source)) +
        geom_bar(position="dodge", stat="identity") +
        geom_text(aes(label=Avg), position=position_dodge(width=0.9), vjust=-0.25)+
        xlab("sentiment type") +
        ylab("average accuracy") +
        ggtitle("Average Accuracy of each News Source") + 
        labs(fill = "news source") +
        theme(plot.title = element_text(size=14, hjust = 0.5)) 
ssource_plot2

########################################## Financial News Sources ##################################################
sentence_level <- rbind(final_GuardianSS,final_SSReuters,final_CNBCss) %>% 
        group_by(Date) %>% 
        mutate(score = mean(ave_sentiment)) %>% 
        mutate(binary_score = case_when(score > 0 ~ "1",
                                        score < 0 ~ "0")) %>% 
        distinct_at(vars(Date), .keep_all = TRUE) 

final_sentence <- subset(sentence_level, select = c(Date, score, binary_score))

financial <- left_join(final_sentence, exchange, by=c("Date")) %>% 
        drop_na()
#write.csv(financial, 'financial_sentence.csv')

financial_GBP <- left_join(final_sentence, exchange2, by=c("Date")) %>% 
        drop_na()
#write.csv(financial, 'financial_sentenceGBP.csv')

word_level <- rbind(sentiword_sentiment_guardian,sentiword_sentiment_reuters,
                    sentiword_sentiment_cnbc) %>% 
        group_by(Date) %>% 
        mutate(score = mean(sum_score)) %>% 
        mutate(binary_score = case_when(score > 0 ~ "1",
                                        score < 0 ~ "0")) %>% 
        distinct_at(vars(Date), .keep_all = TRUE) 

final_word <- subset(word_level, select = c(Date, score, binary_score))

financial2 <- left_join(final_word, exchange, by=c("Date")) %>% 
        drop_na()
#write.csv(financial2, 'financial_word2.csv')

financial_GBP2 <- left_join(final_word, exchange2, by=c("Date")) %>% 
        drop_na()
#write.csv(financial_GBP2, 'financial_wordGBP2.csv')
