
##############################################################################################################
######### SHINY APP FOR VISUALISING AND MODELLING UN DATA FOR LIFE EXPECTANCY BASED ON GDP ###################
##############################################################################################################

# the original UN data for Life expectancy at birth (years) can be found at 
#http://data.un.org/Data.aspx?q=life+expectancy&d=WHO&f=MEASURE_CODE%3aWHOSIS_000001

# the original UN data for GDP/capita can be found at
#http://data.un.org/Data.aspx?q=gdp&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a1

# Load libraries
library(dplyr)
library(shiny)


##############################################################################################################
######################################### PREPARE DATA #######################################################
##############################################################################################################
# Read data
GDP<-read.csv("GDP.csv",stringsAsFactors = FALSE)[,c(1,2,4)]
LifeExpectancy<-read.csv("LifeExpectancy.csv",stringsAsFactors = FALSE)[,c(1,2,3,4)]

# Subset data to look at entire population
LifeExpectancy<-LifeExpectancy[LifeExpectancy$GENDER=="Both sexes",c(1,2,4)]

# Tidy up column names
colnames(GDP)<-c("Country","Year","GDP")
colnames(LifeExpectancy)<-c("Country","Year","LifeExpectancy")

# Join the two datasets
data<-left_join(GDP,LifeExpectancy,by=c("Country","Year"))

# Change country to factor variable
data$Country<-as.factor(data$Country)

# remove lines with NA:s and only use data from the year 2012
data<-data[!is.na(data$GDP) & !is.na(data$LifeExpectancy) & data$Year==2012,]


##############################################################################################################
##################################### SET UP SHINY SERVER ####################################################
##############################################################################################################

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
  # Set up linear model for life expectancy based on GDP/capita
  model1<-lm(LifeExpectancy~GDP,data=data)
  
  # Set up logaritmic model for life expectancy based on GDP/capita
  model2<-lm(LifeExpectancy ~ log(GDP),data=data)
  
  # Predict life expectancy based on chosen GDP from linaer model
  model1pred<-reactive({
    GDP<-input$sliderGDP
    predict(model1,newdata=data.frame(GDP=GDP))
  }) 
  
  # Predict life expectancy based on chosen GDP from logistic model
  model2pred<-reactive({
    GDP<-input$sliderGDP
    predict(model2,newdata=data.frame(GDP=GDP))
  }) 
  
  
  output$plot1<-renderPlot({
      # read chosen GDP
      GDPInput<-input$sliderGDP
      
      # Create scatterplot of actual UN data   
      plot(data$GDP,data$LifeExpectancy,xlab="GDP/Capita [$/capita]",
                ylab="Life Expectancy [yrs]",col="grey", bg="lightgrey", pch=21,
                ylim=c(30,100),
                xlim=c(0,170000))
          # If model 1 is chosen, display prediction in graph
           if(input$selectModel==1 ){
                model1pred<-predict(model1,newdata=data.frame(GDP=GDPInput))
                points(GDPInput,model1pred,col="coral4",pch=21,cex=2,bg="coral")
                # display model fit curve
                if(input$ShowFit==TRUE){
                  abline(model1,col="red",lwd=2)
                }
           }
          # If model 2 is chosen, display prediction in graph
           if(input$selectModel==2){
               model2lines<-predict(model2,newdata=data.frame(
                   GDP=data$GDP[order(data$GDP)] ))
               # display model fit curve
               if(input$ShowFit==TRUE){
                   lines(data$GDP[order(data$GDP)],model2lines,col="deepskyblue3",lwd=2)
               }
               model2pred<-predict(model2,newdata=data.frame(GDP=GDPInput))
                points(GDPInput,model2pred,col="black",pch=21,cex=2,bg="deepskyblue3")
           }
      
           # Show names of actual data on graph
           if(input$ShowCountries==TRUE){
               subset<-data$Country %in% c("Sierra Leone","Hungary","Greece","Japan","Guatemala","India","Kenya","USA","Sweden","Monaco")# & 
               with(data[subset,],points(GDP,LifeExpectancy,col="black",pch=21,cex=1.5,bg="light blue"))
               with(data[subset,],text(x=GDP,y=LifeExpectancy,labels = Country,col="black",adj =c(0.3,1)))
           }
           
            # Create legend
           legend(25,250,c("Model 1 Prediction", "Model 2 Prediction"),pch=16,
                  col=c("coral","deepskyblue3"),bty="n",cex=1.2)
           
       })
 
       # Create output text for prediction
       output$Model1<-renderText({
         if (input$selectModel==1 ){
              paste("Predicted life expectancy from linear model is: ",round(model1pred(),2)," years")
           }else if (input$selectModel==2 ){
              paste("Predicted life expectancy from logaritmic model is: ",round(model1pred(),2)," years")
           }
           })
   
})
