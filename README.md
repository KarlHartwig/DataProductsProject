# DataProductsProject

- Life expectancy in poor countries are on average lower than the life expectancy in wealthier countries.

- However, this relationship is not linear:
  - Increased wealth in very poor countries can have a dramatic impact on population health 
  - Increased wealth in rich countries have little impact on the expected lifetime of the people 
  
  
To illustrate this a shiny app was developed to visualise UN data for [life expectancy][1] and [GDP/capita][2] from 2012. 


[1]: http://data.un.org/Data.aspx?q=life+expectancy&d=WHO&f=MEASURE_CODE%3aWHOSIS_000001 "UN Life Expectancy Data"
[2]:http://data.un.org/Data.aspx?q=gdp&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a1 "GDP/capita"


# Description of App

- The app includes visualisations of example countries as well as a logaritmic regression model for predicting the life expectancy of a country based on GDP data supplied by the user. 

- The default model used for the prediction of country life expectancy is a linear model applied to a logaritmic transformation of the GDP/captia data:     
    y= m*log(x)+b 

where x is the GDP/Capita and y is the average life expectancy of the population. 
The intercept, b, and slope of the regression line, m, are calculated as shown below:

- A standard linear model was also included in the app. However, it should be noted that the predictions made by this model are not realistic and the model is include only to show that the app can be extended to include additional models.
    
- The finished app can be accessed [here][3]  

[3]: https://khartwig.shinyapps.io/lifeexpectancy/ "Shiny App"


