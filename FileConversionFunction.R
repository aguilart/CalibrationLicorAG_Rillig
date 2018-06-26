

#Function to convert the excel file output of the LiCor as a list, that includes a dataframe with the
#variables CO2 (reference and sample), an identificaion of which sample "T1, T2..", a correla
#tive number and also the flow a which the CO2 was measured. The other component of the list is
#metadata associated with the each file (the date at which it the sample was measured, the settings
#of the machine, etc).

mock<-data.frame(V1="Mock",V42="Mock",V43="Mock",V48="Mock",Sample="Mock")

Convertir<- function(x){
              Meta<-x[c(1:18)]
              x<-x[-c(1:11),c(1,42,43,48)]
              x<-data.frame(x,Sample=vector("double",length(x[[1]])))
              x<-rbind(x,mock)
              x$Sample[grep("Remark=",x$V1)+1]<-"T"
              x<-x[-grep("Remark=",x$V1),]
              x$Sample[(grep("T",x$Sample))]<-
                paste(x$Sample[grep("T",x$Sample)],c(1:length(x$Sample[(grep("T",x$Sample))])),sep = "_")
              
              w<-grep("T",x$Sample)
              k<-x$Sample[grep("T",x$Sample)]
              z<-vector("numeric",(length(k)+1))
              #z<-numeric()
              for(t in 1:(length(w)-1)){
                z[w[t]:w[t+1]]<-rep(k[t],length(w[t]:w[t+1]))}
              
              x$Sample<-z
              rownames(x)<-NULL
              names(x)[1:4]<-x[1,1:4]
              
              x<-x[-c(1,2,length(x[[1]])),]
              
              x<-list(Meta,data.frame(apply(x[1:4],2,as.numeric),x[5]))
              }

getPeaks<-function(x){
              x<-data.frame(tapply(x$CO2R,x$Sample,max))
              x$Sample<-rownames(x)
              names(x)[1]<-c("Peaks")
              x$Peaks<-as.numeric(x$Peaks)
              x$Sample<-as.numeric(sub("T_","",x$Sample))
              x<-x[order(x$Sample),]
              rownames(x)<-NULL
              x
            }