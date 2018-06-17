###############################################################################################
###########################Calibration protocol for the Licor##################################
###############################################################################################

#Note! Licor measures CO2 as concentration in umol/mol which is the same as ppm!

# To calibrate CO2 injected in the Licor, one needs to inject in the Licor a volume of
#air with a known concentration of CO2. Max and Carlos (on mid August 2017) did this calibration.
#They use the Licor machine itself to produce and collect certain concentration of CO2 
#because the machine can also do that.To learn how to produce these values look at the
#PDF entitled "Producing_Known_CO2 With Licor"

#The concentrations they used were the following:

KnownCO2<-c(43.3,45.3,66.0,88.8,115.9,195.8,316.6,528.4,1056.1,2199.8)

#Then they injected 5ml of each of these concentrations and recorded (using the AutoLog setting
#of the LiCor) the CO2 reads for 1 minute, saved in a file called "calibration mixer off 15.8.17_.csv"


AugustCalibrationData<-read.csv("calibration mixer off 15.8.17_.csv",header = F,stringsAsFactors = F)
                        AugustCalibrationData<-Convertir(AugustCalibrationData)
                        AugustCalibrationData<-AugustCalibrationData[[2]]

                      ##NOTES on the data recorded
                                              
                      #For each recorded sample, the data looks like a humped shaped curve, with a clear maximum.
                      #Why one gets such a curve? Although it is not clear (at least to clear to Carlos), this curve
                      #is obtained because the LiCor measures real time CO2 values that passess through the sensor at
                      #a constant flow rate of CO2 free air (the flow is set by the machine). When we start injecting
                      #the CO2, most of the air that gets to the sensor is still CO2 free air (low values), but as we
                      #keep injecting, most of the air that passes through the sensor comes from our sample (the peak)
                      #and as we finish the air is again mostly the CO2 free air (low values again). Thus, the peak
                      #value is represents the best the concentration from our sample.
                                              
                      #Now this peak is dependent on 3 factors:
                      # 1) The flow rate (unless changed in the setting, this flow remains constant because LiCor
                      #    can maintained in this way). 
                      # 2) The volume of air injected: the more volume, the "longer" it takes for the sensor to 
                      #    capature the real concentration of our sample.
                      #   (Take a look at figure 2 in the pdf: LI-8100A_Small_Volume_TechNote to see this effect).
                      #3) The speed at which one injects. 
                                              
                      #Thus it is recomended to 1) Always use the same flow rate; 2) A calibration curve is needed to
                      #for given volumes used; 3) Inject the samples at the same rate every time (from what I understand)
                      #one does not need to be so excat)
                        
#To continue with the calibration process, the peaks of each curve were extracted:
                        
AugustCalPeaks<-data.frame(
                tapply(AugustCalibrationData$CO2S,AugustCalibrationData$Sample,max))
                AugustCalPeaks$Sample<-rownames(AugustCalPeaks)
                names(AugustCalPeaks)[1]<-c("Peaks")
                AugustCalPeaks<-AugustCalPeaks[c(1,3:10,2),]
                AugustCalPeaks$Peaks<-as.numeric(AugustCalPeaks$Peaks)
                rownames(AugustCalPeaks)<-NULL
  
#Now this peaks are plotted against the known concentration where they come from; and then one 
#calculates the regression line to obtain a conversion factor from peak to real concentration

        # 1- Plotting the relationship
                  library(tidyverse)
                  
                  ggplot()+
                    aes(x=rev(AugustCalPeaks$Peaks),y=KnownCO2)+
                    geom_point()+
                    labs(x="Observed Peak Concentration for 5ml (ppm)",
                         y="Known sample concentration (ppm)")+
                    geom_smooth(method=lm,se=F)+
                    ggtitle(label = "Max & Carlos calibration August 2017")
        #2- Fitting a line
          summary.lm(lm(KnownCO2~rev(AugustCalPeaks$Peaks)))
          
#THUS; THE CONVERSION FACTOR FOR UNKNOWN SAMPLES OF:
          #1) 5ml VOLUMES OF CO2 INJECTED TO THE LICOR;
          #2) AT FLOW RATE OF 300umol/second
          
          #Is:
          
          Conversion5ml<-function(x){x<-(38.25*x)-265}
  
#NOTES THIS CONVERSION
          
#Althought line fits really nicely the data. It seems that for samples of 5ml containing
#concentration below 60, the fitted values are not that accurate. It seems like that this why
#the technical notes suggest to use better less volumes. One can see clearly when comparing the
#fitted values to the known concentrations:
  
          Comparison<-data.frame(
            ObservedPeaks=rev(AugustCalPeaks$Peaks),KnownCO2,
            FittedValues=(rev(AugustCalPeaks$Peaks)*38.25)-265)