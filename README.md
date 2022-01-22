# Predicting Forex with Sentiment Analysis
An undergraduate research in predicting Forex movement with sentiment analysis of news headlines. 

## Overview
There are 3 major parts in the project: 
1. Extraction of news headlines from news sources (CNBC, NY Times, Reuters, Guardian).
2. Sentiment scoring of the news headlines using word level and sentence level. 
3. The binary score of the daily Forex movement (EUR-USD/GBP-USD) is used as the target variable whereas the sentiment score is the independent variable. 

## Objectives
To illustrate the accuracy of the fundamental analysis approach in the presence of market uncertainties.
To investigate the difference in processing of the sentiment score of the news headlines and its accuracy in predicting the FOREX movement.
To explore the effect of positive and negative sentiment news headlines on FOREX prediction.
To compare the news sources to see the difference in reporting by emotion.

## Forex data
The Forex data was extracted from the open source website of historical Forex data. The link to the website: https://forexsb.com/historical-forex-data. 

In this study, the data collected is with the interval of a day (D1) for two years, 2019 to 2020. The currency pairs are:
1. EUR/USD. It is the most traded currency pair in the world.
2. GBP/USD. A currency pair to compare with EUR/USD.

The data preparation for both pairs includes changing the Time to Date in order to facilitate the later part of merging the datasets and a dummy variable with the name “binary close” was created to get a categorical value of the Close variable. 

## News sources
There are 4 news sources extracted in this study. They are: 
1. Reuters. The data consists of only financial news which was retrieved from Kaggle (https://www.google.com/url?q=https%3A%2F%2Fwww.kaggle.com%2Fnotlucasp%2Ffinancial-news-headlines&sa=D).  
2. CNBC. Likewise Reuters, this data was also from the same source and contains only financial news.
3. The Guardian. The news source was extracted using the tool, Orange, with the filter of "financial". 
4. NY Times. Python programming was utilized to scrape the news headlines data from the news website using their API. This news source is only for major news in which the headlines were chosen if the news are in CNN. 

A category, financial news, was created which is the merging of the financial news sources (Reuters, CNBC and The Guardian). All of the news sources needed some minor cleaning.  

## Sentiment analysis
Sentiment analysis is a procedure of determining the sentiment out of the text. The result of a sentiment score of a sentence could be in negative, neutral or positive. In this report, the methods used to determine the sentiment of the headlines are: 
1. Word level analysis. This method is through pre-processing steps which includes text tokenization, normalization, stop words filtering and negation handling. 
2. Sentence level analysis. A package, Sentimentr from R calculates text polarity sentiment at the sentence level. It means that without breaking down the words, the sentiment scoring is done on the sentence as a whole. 
The data of the sentiment score and the Forex data is then merged together for the prediction analysis. 

## Modelling techniques
There are several algorithms used in this research to predict the accuracy of Forex movement using the sentiment score of the news headlines. The data was trained and validated using Pareto Principle of 80/20 rule wherein 80% of the effect is due to the 20% of the cause. Other ratios of 90/10, 70/30 and 60/40 were also fitted into the model for comparison where 80/20 resulted in the best accuracy. 
The machine learning algorithms used are: 
1. Support Vector Machine 
2. Logistic Regression
3. Decision Tree
4. K Nearest Neighbor
5. Gaussian Naïve Bayes

The open-source software Python Jupyter Notebook was used to run the algorithms applying libraries such as sklearn, pandas, numpy and seaborn. The modelling was done on the different type of news sources in word level and sentence level. It was also completed on the Forex data without sentiment score. Modelling on the effect of positive and negative news headlines was tested on the best models. 

## Some background of codes
Sentiment analysis: 
The uploaded code is for Guardian but the same code can be used for the other news sources. 

Modelling:
The codes for the modelling part of the study are almost all similar. The only difference is the data source of the different news sources and whether the sentiment scoring is word level and sentence level. For example: NY Times/CNBC/Reuters/Guardian + Sentence level score + EUR-USD/GBP-USD or NY Times/CNBC/Reuters/Guardian + Word level score + EUR-USD/GBP-USD. Using Forex data to predict without sentiment score for both EUR/USD and GBP/USD is the same code, only changing the data source. 

Scraping news headlins: 
For Guardian, it was scraped from the software Orange. 
NY Times was scraped using python. 

Other codes: 
This codes contains the data understanding part and some visualization including the only financial news sources sentiment analysis. 
