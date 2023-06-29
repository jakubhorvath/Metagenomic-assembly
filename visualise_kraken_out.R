#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)
install.packages(c("ggplot2", "taxonomizr"))
library(ggplot2)
library(taxonomizr)
kraken_report <- args[1]
print(kraken_report)
results_path <- args[2]
print(results_path)

kreport<-read.delim(kraken_report, sep ='\t', header=F)

#preview
head(kreport)

x <- transform(fam.kreport, variable=reorder(sciName, -readsRooted) ) 
x = x[order(-x$readsRooted),]


ggplot(data=x[1:9,]) +
  geom_bar(aes(x=sciName, y = readsRooted), stat='identity') +
  theme(axis.text.x=element_text(angle=90))

ggsave("top_n_taxa.png", width = 10, height = 10)


ggplot(data=kreport, aes(x=log(readsRooted), y=log(percent))) +
  geom_point() + 
  geom_text(aes(label=sciName),hjust=0, vjust=0, size=2)

ggsave("taxa_scatter.png", width = 10, height = 10)
