library(ggplot2)
library(scales)

# function creates labels with total number of queries
create_feature_labels_list <- function() {
  features <- unique(prep_data$feature)
  feature_lables <- c()
  for (feature in features) {
    feature_queries_binaryFeature0 <- sum(prep_data[(prep_data$feature == feature & prep_data$binaryFeature == "0"), "count"])
    feature_queries_binaryFeature1 <- sum(prep_data[(prep_data$feature == feature & prep_data$binaryFeature == "1"), "count"])
    feature_queries_binaryFeature0 <- paste0("binaryFeature = 0 (", feature_queries_binaryFeature0, ")")
    feature_queries_binaryFeature1 <- paste0("binaryFeature = 1 (", feature_queries_binaryFeature1, ")")
    feature_queries_total <- paste0("(", sum(prep_data[prep_data$feature == feature, "count"]), ")")
    feature_queries_total <- paste(feature, feature_queries_total, sep = " ")
    feature_lables[feature] <- paste(feature_queries_total, feature_queries_binaryFeature0, feature_queries_binaryFeature1, sep = "\n")
  }
  
  feature_lables["_Outcome"] <- "Target Variable"
  return(feature_lables)
}

# load and prepare dataset
dataset <- read.csv("dataset.csv", sep=";", header = FALSE)
column_names <- c('feature', 'dummy', 'binaryFeature', 'timestamp', 'count')
names(dataset) <- column_names
dataset$timestamp <- as.Date(dataset$timestamp, "%Y/%m/%d")

# create dataset for the chart
dates_sequence <- seq(as.Date("2018/10/1"), as.Date("2019/01/31"), by= "day")
features <- unique(dataset$feature)
dummys = unique(dataset$dummy)
dummys <- dummys[dummys != "Outcome"]
binaryFeatures <- c("0","1")
prep_data <- expand.grid(date = dates_sequence, feature = features, binaryFeature = binaryFeatures)
prep_data <- merge(prep_data, dataset, by.x = c("date","feature","binaryFeature"), by.y = c("timestamp","feature", "binaryFeature"), all.x = TRUE)
prep_data[is.na(prep_data$count) == TRUE, "count"] <- 0
prep_data$feature <- as.character(prep_data$feature)
prep_data<-prep_data[!(prep_data$feature == "Outcome" & prep_data$binaryFeature == "0"), ]
prep_data[prep_data$feature == "Outcome", "feature"] <- "_Outcome"

# create and show time series plot
ggplot(prep_data, aes(x = date, y = count, colour = binaryFeature)) + 
  geom_line() + 
  facet_grid(feature ~., labeller =  labeller(feature = create_feature_labels_list())) +
  scale_x_date(labels = date_format("%d-%m-%y")) +
  theme(strip.text.y = element_text(angle=0, hjust = 0))
