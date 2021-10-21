---
categories:  
- ""    #the front matter should be like the one found in, e.g., blog2.md. It cannot be like the normal Rmd we used
- ""
date: "2021-09-30"
description: Some example of my work with R # the title that will show up once someone gets to this page
draft: false
image: group-of-people-clinking-glasses-because-they-are-drinking-together.jpg # save picture in \static\img\blogs. Acceptable formats= jpg, jpeg, or png . Your iPhone pics wont work

keywords: ""
slug: R # slug is the shorthand URL address... no spaces plz
title: R
---


```{r setup, echo=FALSE}
knitr::opts_chunk$set(
  message = FALSE, 
  warning = FALSE, 
  tidy=FALSE,     # display code as typed
  size="small")   # slightly smaller font for code
options(digits = 3)

# default figure size
knitr::opts_chunk$set(
  fig.width=6.75, 
  fig.height=6.75,
  fig.align = "center"
)
```


# Loading necessary packages:

Code loads the necessary packages to analyze the data and present the charts. (Not included in HTML)

```{r load-libraries, echo=FALSE, message=FALSE, warning=FALSE}
library(tidyverse)  # Load ggplot2, dplyr, and all the other tidyverse packages
library(mosaic)
library(ggthemes)
library(lubridate)
library(fivethirtyeight)
library(here)
library(skimr)
library(janitor)
library(vroom)
library(tidyquant)
library(rvest) # to scrape wikipedia page
```



# Where Do People Drink The Most Beer, Wine And Spirits?

Back in 2014, [fivethiryeight.com](https://fivethirtyeight.com/features/dear-mona-followup-where-do-people-drink-the-most-beer-wine-and-spirits/) published an article on alcohol consumption in different countries. The data `drinks` is available as part of the `fivethirtyeight` package which will be used here.

We load the 'fivethirtyeight' package and drinks dataset with the code below:


```{r load_alcohol_data}
library(fivethirtyeight)
data(drinks)


# or download directly
alcohol_direct <- read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/alcohol-consumption/drinks.csv")

```

Following this we can skim and glimpse the data in order to see if there are any missing values we should worry about and to see the data and variable types.

```{r glimpse_skim_data}
skim(alcohol_direct)
glimpse(alcohol_direct)

```

The overview seems to have a comprehensive number of variables. However, some countries have zero total consumption, hence we believe the data is not comprehensive and complete. The variable types are numeric and characters for the country variable.

Below a plot is presented to show the top 25 beer drinking countries:

```{r beer_plot}
alcohol_direct %>% #loading the dataset
  slice_max(order_by = beer_servings, n=25) %>% #sorting by top 25 countries
  ggplot(aes(x = beer_servings, y = reorder(country, beer_servings))) + #Choosing variables on each axis and sorting to have the highest countries on top.
  geom_col(fill = "Orange") + #Making the graph orange
  labs(title = "Namibia is the most beer-consuming country", #This line and the ones below add titles and axis
       subtitle = "Beers consumed by country, top 25 countries woldwide, 2010", 
       x = "Beer servings per person",
       y = "Country",
       caption = "https://fivethirtyeight.com/features/dear-mona-followup-where-do-people-drink-the-most-beer-wine-and-spirits/") + 
  theme_bw() + #Making a more simple theme
  NULL

```
From the graph it is evident that Namibia drinks the most beers per capita and that some countries drink up toward one beer per day per capita. 


We now want to see the top 25 wine producing countries. 

```{r wine_plot}

alcohol_direct %>% #Loading the dataset
  slice_max(order_by = wine_servings, n=25) %>% #Sorting for top 25 countries
  ggplot(aes(x = wine_servings, y = reorder(country, wine_servings))) + #Choosing variable types and sorting the variables by servings
  geom_col(fill = "Darkred") + #Making the bars dark red fitting with the wine theme
  labs(title = "France is the most wine-consuming country", #This section adds titles
       subtitle = "Wine consumed by country, top 25 countries worldwide, 2010", 
       x = "Wine servings per person",
       y = "Country",
       caption = "https://fivethirtyeight.com/features/dear-mona-followup-where-do-people-drink-the-most-beer-wine-and-spirits/") + 
  theme_bw() + #Adding a more simple theme
  NULL



```

We see that especially France and Portugal drinks a lot of wine per capita also equivalent of a unit per day per person like the top beer drinking countries. There is a bit further span on the top 25 wine-drinking countries where the lowest countries are as low as around 160 compared to 240 for beer drinking countries. 

Finally, we make a plot that shows the top 25 spirit consuming countries

```{r spirit_plot}

alcohol_direct %>% #choosing the data
  slice_max(order_by = spirit_servings, n=25) %>% #sorting by top 25 countries
  ggplot(aes(x = spirit_servings, y = reorder(country, spirit_servings))) + #plotting variables and reordering by top max on top
  geom_col(fill = "Darkgreen") + #Making the plot dark green
  labs(title = "Grenada is the most spirit-consuming country",#adding titles
       subtitle = "Spirit consumed by country, top 25 countries worldwide, 2010", 
       x = "Spirit servings per person",
       y = "Country",
       caption = "https://fivethirtyeight.com/features/dear-mona-followup-where-do-people-drink-the-most-beer-wine-and-spirits/") + 
  theme_bw() + 
  NULL


```
Here we see that Grenada is the highest spirits drinking country but also the country with the most units for a single alcohol type with approximately 430 units. 

While these three charts show the overall consumption of different types of alcoholic beverages, the top 25 countries differ highly by category because each country has a high preference for one certain type of alcohol. For the same reason, we cannot infer whether these countries are the highest alcohol-consuming countries overall. Furthermore, it seems that within all categories the top 25 countries drink approximately 150-370 servings. This is with the exception of Grenada where spirit servings are above 400 units. This could likely indicate a preference for spirits also could be due to a lack of availability of other alcohol types in the country.

In addition to the above, the graphs show units per person so we cannot infer which country has the highest total consumption of units. For example although Grenada has the highest number of units per person their total consumption can be lower than that of other countries because of the low population. 

Furthermore, this data shows per capita consumption, however, it would be interesting to dive deeper into how this is segmented throughout the countries, i.e. if certain segments have much higher consumption than others. 

The data is from 2010 and consumption might have changed since then.


```