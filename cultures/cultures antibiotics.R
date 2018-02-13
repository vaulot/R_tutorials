library("ggplot2")
library("gridExtra")
library("plotrix" ) # needed for standard error
library("dplyr")
library("tidyr")
library("stringr")

#=================================================================
#    Antibio treatment
#=================================================================
cell<- read.table("cultures 02.txt", header=TRUE, sep="\t", na.strings="NA", dec=".", strip.white=TRUE)
cell<- gather(cell, X1:X7, key = "day", value = "cell_number") 
cell$day<-as.numeric(str_replace(cell$day, "X", ""))
cell$Concentration<-as.character(cell$Concentration)

cell_1<- cell %>% group_by(RCC,Antibio,Concentration, day)%>%
         summarise (cell_mean=mean(cell_number),cell_sd=sd(cell_number), cell_se=std.error(cell_number))

Concentration_color<-c("0.2"="white","0.5"="white", "0.8"="white", "1"="black", "1.5"="black", "2"="black")
Concentration_linetype<-c("0.2"=1,"0.5"=1, "0.8"=1, "1"=2, "1.5"=2, "2"=2)
Concentration_shape<-c("0.2"=21,"0.5"=22, "0.8"=21, "1"=22, "1.5"=21, "2"=22)

scaling_factor=15
cell_label <- expression (paste("cell.",mL^-1))
cell_breaks=c(100,1000,10000,100000,1000000)
x_max=8
x_breaks=c(0, 2,4,6,8)
x_labels=c("0", "2","4","6","8")

#plot1<-
ggplot(cell_1, aes(x=day, y=cell_mean, group = Concentration, xmin=0, xmax=x_max, shape=Concentration, fill=Concentration, linetype=Concentration)) + 
  facet_wrap(~ RCC + Antibio, nrow=4, ncol=2, scales="free") +
	geom_line (size=0.8, colour="black") + 
  geom_point(size = 4) + 
  geom_errorbar(aes(ymin=cell_mean-cell_se, ymax=cell_mean+cell_se),width=0.2, linetype=1) +
  theme_bw(scaling_factor) + 
  theme(panel.border = element_rect(colour = "black"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),	
        axis.line = element_line(colour = "black"), 
		    legend.title=element_text(size=scaling_factor), legend.key=element_blank(),
		    axis.title = element_text(size=scaling_factor), 
		    legend.text=element_text(size=scaling_factor), legend.key.height = unit(1, "cm"), 
		    axis.text = element_text(size=0.8*scaling_factor), panel.background = element_rect(fill="white")) + 
	theme(legend.position = "top", legend.box = "horizontal")  +
	labs(x = "Days", y = cell_label ) +
  scale_x_continuous(breaks=x_breaks, labels=x_labels) + 
	scale_y_log10(breaks = cell_breaks ,labels = scales::trans_format("log10", scales::math_format(10^.x))) + 
  annotation_logticks(sides = "lr") + 
	scale_fill_manual(values=Concentration_color) + 
  scale_shape_manual(values=Concentration_shape) + 
  scale_linetype_manual(values=Concentration_linetype)

		
		# coord_cartesian(ylim=c(100, 10000000)) + # Add next line to zoom		
		
#ggsave(file="Fig 1 version 2.0.pdf", plot=plot1, scale=5, width = 7, height = 10, units = "cm", useDingbats=FALSE)

