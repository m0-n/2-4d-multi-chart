library(ggplot2)
library(scales)

# function creates labels with total number of queries
create_keyword_labels_list <- function() {
  keywords <- unique(gso_data$keyword)
  keyword_lables <- c()
  for (keyword in keywords) {
    keyword_queries_urlCall0 <- sum(gso_data[(gso_data$keyword == keyword & gso_data$urlCall == "0"), "count"])
    keyword_queries_urlCall1 <- sum(gso_data[(gso_data$keyword == keyword & gso_data$urlCall == "1"), "count"])
    keyword_queries_urlCall0 <- paste0("flag = 0 (", keyword_queries_urlCall0, ")")
    keyword_queries_urlCall1 <- paste0("flag = 1 (", keyword_queries_urlCall1, ")")
    keyword_queries_total <- paste0("(", sum(gso_data[gso_data$keyword == keyword, "count"]), ")")
    keyword_queries_total <- paste(keyword, keyword_queries_total, sep = " ")
    keyword_lables[keyword] <- paste(keyword_queries_total, keyword_queries_urlCall0, keyword_queries_urlCall1, sep = "\n")
  }
  
  keyword_lables["ARANKING"] <- "Target Variable"
  return(keyword_lables)
}

# load and prepare dataset
gso_newplacement <- read.csv("C:\\d_newplacement.csv", sep=";", header = TRUE)
column_names <- c('keyword', 'queryType', 'urlCall', 'timestamp', 'count')
names(gso_newplacement) <- column_names
gso_newplacement$timestamp <- as.Date(gso_newplacement$timestamp, "%Y/%m/%d")

# create dataset for the chart
dates_sequence <- seq(as.Date("2018/10/1"), as.Date("2019/01/31"), by= "day")
keywords <- unique(gso_newplacement$keyword)
queryTypes = unique(gso_newplacement$queryType)
queryTypes <- queryTypes[queryTypes != "RANKING"]
urlCalls <- c("0","1")
gso_data <- expand.grid(date = dates_sequence, keyword = keywords, urlCall = urlCalls)
gso_data <- merge(gso_data, gso_newplacement, by.x = c("date","keyword","urlCall"), by.y = c("timestamp","keyword", "urlCall"), all.x = TRUE)
gso_data[is.na(gso_data$count) == TRUE, "count"] <- 0
gso_data$keyword <- as.character(gso_data$keyword)
gso_data<-gso_data[!(gso_data$keyword == "RANKING" & gso_data$urlCall == "0"), ]
gso_data[gso_data$keyword == "RANKING", "keyword"] <- "ARANKING"

# create and show time series plot
ggplot(gso_data, aes(x = date, y = count, colour = urlCall)) + 
  geom_line() + 
  facet_grid(keyword ~., labeller =  labeller(keyword = create_keyword_labels_list())) +
  scale_x_date(labels = date_format("%d-%m-%y")) +
  theme(strip.text.y = element_text(angle=0, hjust = 0))
