
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "style.css",
  
  # Application title
  titlePanel("Life Expectancy based on GDP/Capita"),
  
  # Set up sidebar with a slider for selecting output, check boxes for display options and drop down list for model selection.
  sidebarLayout(
    sidebarPanel(
       sliderInput("sliderGDP", "What is the GDP per capita in USD for the country?",1,150000, value = 20000),
       selectInput("selectModel", label = h3("Select model"), 
                   choices = list("Linear Regression" = 1, "Logarithmic Regression" = 2), 
                   selected = 2),
       checkboxInput("ShowFit","Show Regression Model Fit", value=TRUE),
       checkboxInput("ShowCountries","Show Example Countries", value=FALSE),
       div(h3("Background"),p("This app visualises UN data for ", 
                              a(href="http://data.un.org/Data.aspx?q=life+expectancy&d=WHO&f=MEASURE_CODE%3aWHOSIS_000001", "Life Expectancy"),
                              " and " , 
                              a(href="http://data.un.org/Data.aspx?q=gdp&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a1", "GDP/capita"),
            ". (The raw data can be accessed by clicking the link text specified in the previous sentence)."),
           p("The data displayed is from 2012 and the values are aggregated life expectancy for both the male and female population. 
             Two models have been fitted to the data and can be used as outlined below.")),
       div(p(h3("Instructions"),"Use the drop down meny to select the type of model used to predict the life expectancy of a country based on the GDP/capita given as $/capita. 
            The GDP is specified by the slider bar at the top of the sidepanel."),
          p("There is also an option to show a number of example countries through thicking the second check box to give the model prediction some context.")),
       div(p(h3("Model Descriptions"),
            p(h4("Logaritmic Model"),"The default model used for the prediction is a linear model with a logaritmic transformation applied to the GDP/captia information: ",
              br(),"m*log(x)+b ",br(),"where m and b are factors set by least square regression whereas x is the GDP/Capita."),
            p(h4("Linear Model"), "A second linear model is included of standard form: ",
              br()," m*x+b ",
              br(),
              "where m and b are factors set by least square regression whereas x is the GDP/Capita.",
           br(),
            "This model does not result in good predictions for the applied data. 
           Instead it is included to show the possbility of the app to be extended to include multiple models.")

    ))),
    
    # Show plots of model and results
    mainPanel(
       plotOutput("plot1"),
       em(textOutput("Model1"))
    )
  )
))
