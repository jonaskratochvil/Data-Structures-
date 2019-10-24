library("ggplot2")
library("ggthemes")
library("tikzDevice")
library('gridExtra')
library('dplyr') # data manipulation
library('data.table') # data manipulation
library('tibble') # data wrangling
library('tidyr')
install.packages("scales")
library('scales')
library('corrplot') # visualisation
library("ggpubr")

theme_set(theme_bw())

data <- read.csv("sequential_final_header.csv", header = T, sep = ",")

naive_data <- data.frame(skupina="naive", value = data$naive)
std_data <- data.frame(skupina="std", value = data$std)
number_data <- data.frame(data$number)
number_data <- rbind(number_data, number_data)

plot.data_all <- rbind(naive_data, std_data)

ggplot(data = plot.data_all, aes(x= number_data$data.number ,y = value, group = skupina, color=skupina)) + 
  geom_line() +
  ggtitle(paste("Sequential test"))+
  labs(color=NULL) + ylab("rotations")+xlab("n")+
  scale_fill_manual(values=c("red","blue"))+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_y_continuous(trans = log2_trans())

p1
