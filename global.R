

library(tidyverse)
library(ukcovid19) #remotes::install_github("publichealthengland/coronavirus-dashboard-api-R-sdk")
library(paletteer)
library(RcppRoll)
library(lubridate)
library(scales)
library(ragg)
library(ggplot2)
library(dplyr)
library(viridis)

#mapping
library(leaflet)
#install.packages("rgdal")
library(rgdal)
library(RColorBrewer)
library(DT)
library(shiny)
library(googleVis)
library(rsconnect)
library(shinydashboard)

## global.R ##
# convert matrix to dataframe
state_stat <- data.frame(state.name = rownames(state.x77), state.x77)
# remove row names
rownames(state_stat) <- NULL
choice <- colnames(state_stat)[-1]


# cases.reg <- read.csv("covidcases.csv", header=TRUE)
# 
# cases.ltla.reg <- read.csv("Local_authority_wise_cases_21082021.csv", header=TRUE)
# 
# topoData <- rgdal::readOGR("Local_Authority_Districts_(May_2021)_UK_BUC.geojson")


cases.reg <- read.csv("./Data/covidcases.csv", header=TRUE)

cases.ltla.reg <- read.csv("./Data/Local_authority_wise_cases_21082021.csv", header=TRUE)

topoData <- rgdal::readOGR("./Data/Local_Authority_Districts_(May_2021)_UK_BUC.geojson")

data_table <- cases.reg %>% 
  select("Date"="date", "Cases" = new.cases, "Deaths"=deaths, "Hopsitalised_patients"=hosp.cases, "Mechanicaly_ventilated"=MV.beds, "First_vaccine_dose"=vaccine.first, "Second_vaccine_dose"=vaccine.second, vaccine.complete)
