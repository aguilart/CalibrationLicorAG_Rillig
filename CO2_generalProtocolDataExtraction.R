#########################################################################################
#########################Protocol for extracting CO2 data ###############################
#########################################################################################

#A. BASICS

#1. Install both R and Rstudio!!!!

#2. Once Rstudio is install, open it then go to: File>New Project
#There, select the folder where you want your R project to be installed and name the Rproject

#B. Loading file

#1. Open the excel file generated automatically by the LiCor machine and save as ".csv" file
# (comma delimeted file). And add in the last row column A: "Remark="

#2. Load the file using the following code: 

mix<-read.csv("Jenny22.08.19 Messung nach Inkubationszeit.csv",header = F, stringsAsFactors = F)

zero<-read.csv("microplastic_drought2_.csv",header = F, stringsAsFactors = F)
zero_<-read.csv("microplastic_drought_.csv",header = F, stringsAsFactors = F)

#3. Transform the file to the desired format using Covertir function (run first
#the script "FileConversionFunction.R)

mix1<-Convertir(mix)
zero1<-Convertir(zero)
zero1_<-Convertir(zero_)

#4. Get the peaks per sample injected

Mix_Peaks<-getPeaks(mix1)
Mix_Peaks$Sample[21:40]<-c(1:20)
Mix_Peaks$Sample<-paste("P",Mix_Peaks$Sample,sep = "_")
plot(Mix_Peaks$Peaks[1:20],Mix_Peaks$Peaks[21:40])
Mix_Peaks<-data.frame(Peaks=tapply(Mix_Peaks$Peaks,Mix_Peaks$Sample,mean),
                      Sample=rownames(tapply(Mix_Peaks$Peaks,Mix_Peaks$Sample,mean)),
           stringsAsFactors = F);rownames(Mix_Peaks)<-NULL

  
zero_Peaks<-getPeaks(zero1)
#Solving the issue that some samples were measured twice or in a bad way:
zero_Peaks<-zero_Peaks[c(1:10,11:17,20:22),]; rownames(zero_Peaks)<-NULL ; zero_Peaks$Sample<-rownames(zero_Peaks)
zero_Peaks$Sample<-paste("P",zero_Peaks$Sample,sep = "_")


#
zero_Peaks_<-getPeaks(zero1_)

#5. Convert peaks into real CO2 concentration (ppm) using the conversion factor
#for injections of 1ml

Mix_Peaks$Peaks_converted<-Mix_Peaks$Peaks*167
zero_Peaks$Peaks_converted<-zero_Peaks$Peaks*167
zero_Peaks_$Peaks_converted<-zero_Peaks_$Peaks*167

library(tidyverse)

AllData<-left_join(Mix_Peaks,zero_Peaks[,c(2:3)], by ="Sample")
names(AllData)[3]<-"Final_CO2"
names(AllData)[4]<-"Initial_CO2"

AllData$net_CO2_ppm<-AllData$Final_CO2-AllData$Initial_CO2

AllData<-left_join(AllData,
                   data.frame( Sample=paste("P",c(1:20),sep = "_"),
                               Water_Treatment=rep(rep(c("Control","Drought"),each=5),2),
                               Microplastic_Treatment=rep(c("No","Yes"),each=10),
                               stringsAsFactors = F),
          by = "Sample")



#write.csv(Mix_Peaks,"Aleksandra_peaksCO2.csv")


#5. Make Boxplots

#You need first to install the package tidyverse          

AllData%>%
ggplot()+
  aes(x=Water_Treatment,y=net_CO2_ppm,color=Microplastic_Treatment,fill=Microplastic_Treatment)+
  geom_boxplot(position=position_dodge(0.8))+
  geom_jitter(position=position_dodge(0.8),color="black")+
  labs(y="CO2 (ppm)")+
  #geom_text(aes(label=Sample))+
  ggtitle(label="Soil Respiration")+
  theme(title = element_text(size = 25),
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20),
        legend.text = element_text(size=10))

head(AllData)
write.csv(AllData,"Soil_respiration.csv",row.names = F)