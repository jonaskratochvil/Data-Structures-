library("ggplot2")
library("ggthemes")
library("tikzDevice")
library('gridExtra')
library('dplyr') # data manipulation
library('data.table') # data manipulation
library('tibble') # data wrangling
library('tidyr')
install.packages("ggpubr")
library('corrplot') # visualisation
library("ggpubr")


theme_set(theme_bw())
data <- read.csv("table_new_wer.csv", header = T, sep = ",")
data2 <- read.csv("table_new_wer_recognized_by_all.csv", header = T, sep = ",")

summary(data2)

all_janus <- data.frame(skupina="JRTk", value = data$Janus)
all_google <- data.frame(skupina="Google", value = data$Google.API)
all_kaldi <- data.frame(skupina="Kaldi BBC", value = data$Kaldi.BBC)

notall_janus <- data.frame(skupina="JRTk", value = data2$Janus)
notall_google <- data.frame(skupina="Google", value = data2$Google.API)
notall_kaldi <- data.frame(skupina="Kaldi BBC", value = data2$Kaldi.BBC)

plot.data_all <- rbind(all_google, all_kaldi, all_janus)
plot.data_notall <- rbind(notall_google, notall_kaldi, notall_janus)

p1 <- ggplot(data = plot.data_all, aes(x=skupina,y = value, fill=skupina)) + 
  geom_boxplot()+
  ggtitle(paste("All recordings"))+
  labs(color=NULL) + ylab("WER")+xlab("")+
  scale_fill_manual(values=c("red3","blue", "green4"))+
  theme(plot.title = element_text(hjust = 0.5))

p2 <- ggplot(data = plot.data_notall, aes(x=skupina,y = value, fill=skupina)) + 
  geom_boxplot()+
  ggtitle(paste("Recognized by all"))+
  labs(color=NULL) + ylab("WER")+xlab("")+
  scale_fill_manual(values=c("red3","blue", "green4"))+
  theme(plot.title = element_text(hjust = 0.5))

g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

legend <- g_legend(p1)

tikz(file="boxplot_fnl.tex",width = 6,height = 4.5)
ggarrange(p2, p1, ncol=2, nrow=1, common.legend = TRUE, legend="bottom")
dev.off()

p3 <- ggplot(data = plot.data_bmi, aes(x = value,fill=skupina)) + 
  geom_density(alpha = 0.7)+
  ggtitle(paste(""))+
  labs(color=NULL) + ylab("")+xlab("BMI")+
  scale_fill_manual(values=c("red","blue")) +theme(legend.position = "top")

p4 <- ggplot(data = plot.data_skok, aes(x = value,fill=skupina)) + 
  geom_density(alpha = 0.7)+
  ggtitle(paste(""))+
  labs(color=NULL) + ylab("")+xlab("výskok (cm)")+
  scale_fill_manual(values=c("red","blue"))

legend <- g_legend(p3)

tikz(file="density_fnl.tex",width = 6,height = 4.5)
grid.arrange(p4+theme(legend.position = "none"),p3+theme(legend.position = "none"), legend,layout_matrix=rbind(c(1,2), c(3,3)),heights=c(2,0.3),top="Výška výskoků a BMI hodnoty podle pohlaví")
dev.off()

# Corrplot
data2 %>%
  
  cor(use="complete.obs", method = "spearman") 

  
#  corrplot(type="lower", method="circle", diag=FALSE)

# Wilcox test
# muzi vs zeny skok

wilcox.test(data$skok_zeny,data$skok_muzi)

p5 <- ggplot(data = data, aes(x = skok_muzi)) + 
  geom_histogram(bins = 5, fill = "blue", color = "black")+
  ggtitle(paste(""))+
  labs(color=NULL) + ylab("")+xlab("výskok (cm) muži")+ 
  geom_vline(aes(xintercept=median(data$skok_muzi),color="median"),size=1) +
  geom_vline(aes(xintercept=49.46,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=58.03,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=mean(data$skok_muzi),
                 color="prumer"), size=1) +
  scale_color_manual(name = "", values = c(median = "chocolate1", prumer = "purple",IQR = "gold3")) +theme(legend.position = "top")

p6 <- ggplot(data = data, aes(x = skok_zeny)) + 
  geom_histogram(bins = 5, fill = "red", color = "black")+
  ggtitle(paste(""))+
  labs(color=NULL) + ylab("")+xlab("výskok (cm) ženy")+ 
  geom_vline(aes(xintercept=median(data$skok_zeny),color="median"),size=1) +
  geom_vline(aes(xintercept=30.4,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=40.02,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=mean(data$skok_zeny),
                 color="prumer"), size=1) +
  scale_color_manual(name = "", values = c(median = "chocolate1", prumer = "purple",IQR = "gold3"))


legend <- g_legend(p5)

tikz(file="histogram_fnl2.tex",width = 6,height = 4.5)
grid.arrange(p6+theme(legend.position = "none"), p5+theme(legend.position = "none"),legend,layout_matrix=rbind(c(1,2), c(3,3)),heights=c(2,0.3),top="Histogram výskoků u žen a mužů")
dev.off()

vaha_zeny <- data.frame(skupina="Ženy", value = data2$vaha_zeny)
vaha_muzi <- data.frame(skupina="Muži", value = data2$vaha_muzi)
vyska_zeny <- data.frame(skupina="Ženy", value = data2$vyska_zeny)
vyska_muzi <- data.frame(skupina="Muži", value = data2$vyska_muzi)

plot.data_vaha <- rbind(vaha_zeny, vaha_muzi)
plot.data_vyska <- rbind(vyska_zeny, vyska_muzi)

data3 <- cbind(plot.data_vaha,plot.data_vyska$value)

tikz(file="scatterplot_fnl.tex",width = 6,height = 4.5)
ggplot(data3, aes(x = value,y = plot.data_vyska$value,color = data3$skupina)) + 
  geom_point()+ geom_smooth(method=lm, se = FALSE) + 
  scale_color_manual(values=c("red","blue")) +
  ggtitle(paste("Lineární vztahy mezi výskou a váhou"))+
  labs(color=NULL) + ylab("výska")+xlab("váha") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()

sort(data$BMI_zeny)

dep <- c(data$BMI_zeny,data$BMI_muzi)
indep <- c(data$skok_zeny,data$skok_muzi)

multi.fit = lm(BMI_muzi~skok_muzi, data)

summary(multi.fit)


####################### Ukol #################################

theme_set(theme_bw())
data <- read.csv("data_ukol.csv", header = T, sep = ",")

p7 <- ggplot(data = data, aes(x = Value_1)) + 
  geom_histogram(bins = 7, fill = "green1", color = "black")+
  ggtitle(paste(""))+
    labs(color=NULL) + ylab("")+xlab("PEF (I/s)")+ 
  geom_vline(aes(xintercept=median(data$Value_1),color="median"),size=1) +
  geom_vline(aes(xintercept=5.54,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=8.11,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=mean(data$Value_1),
                 color="prumer"), size=1) +
  scale_color_manual(name = "", values = c(median = "chocolate1", prumer = "purple",IQR = "gold3"))+theme(legend.position = "bottom")

p8 <- ggplot(data = data, aes(x = Value_2)) + 
  geom_histogram(bins = 7, fill = "maroon3", color = "black")+
  ggtitle(paste(""))+
  labs(color=NULL) + ylab("")+xlab("systolický tlak (mmHg)")+ 
  geom_vline(aes(xintercept=median(data$Value_2),color="median"),size=1) +
  geom_vline(aes(xintercept=109.0,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=122.0,color="IQR"),size=1,linetype="dashed") +
  geom_vline(aes(xintercept=mean(data$Value_2),
                 color="prumer"), size=1) +
  scale_color_manual(name = "", values = c(median = "chocolate1", prumer = "purple",IQR = "gold3"))

legend <- g_legend(p7)
tikz(file="histogram_hw.tex",width = 6,height = 4.5)
grid.arrange(p7+theme(legend.position = "none"), p8+theme(legend.position = "none"),legend,layout_matrix=rbind(c(1,2), c(3,3)),heights=c(2,0.3),top="Histogram naměřených veličin")
dev.off()


tikz(file="lmodel.tex",width = 6,height = 4.5)
ggplot(data, aes(x = Value_2,y = Value_1, color ="red")) + 
  geom_point()+ geom_smooth(method=lm, se = FALSE, color = "blue", alpha = 0.8) + 
  ggtitle(paste("Lineární vztahy mezi výskou a váhou"))+
  labs(color=NULL) + ylab("PEF (I/s)")+xlab("systolický tlak (mmHg)") +
  theme(plot.title = element_text(hjust = 0.5))+theme(legend.position = "none")
dev.off()

# corr
data %>% cor(use="complete.obs", method = "spearman") 

# lm
multi.fit = lm(Value_2~Value_1, data=data)
summary(multi.fit)
# intercept: 99.152 ,  slope: 2.362




# PEF (I/s), systolický tlak (mmHg)