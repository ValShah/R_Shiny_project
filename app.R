##Global####

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
library(shinydashboard)

#mapping
library(leaflet)
#install.packages("rgdal")
library(rgdal)
library(RColorBrewer)
library(DT)
library(shiny)
library(googleVis)
library(rsconnect)



cases.reg <- read.csv("./Data/covidcases.csv", header=TRUE)

cases.ltla.reg <- read.csv("./Data/Local_authority_wise_cases_21082021.csv", header=TRUE)

topoData <- rgdal::readOGR("./Data/Local_Authority_Districts_(May_2021)_UK_BUC.geojson")


# cases.reg <- read.csv("C:/Users/Vallari/Desktop/NYC_academy/R/R_intro lectures/R_Shiny_project/Data/covidcases.csv", header=TRUE)
# 
# cases.ltla.reg <- read.csv("C:/Users/Vallari/Desktop/NYC_academy/R/R_intro lectures/R_Shiny_project/Data/Local_authority_wise_cases_21082021.csv", header=TRUE)
# 
# topoData <- rgdal::readOGR("C:/Users/Vallari/Desktop/NYC_academy/R/R_intro lectures/R_Shiny_project/Data/Local_Authority_Districts_(May_2021)_UK_BUC.geojson")

data_table <- cases.reg %>% 
  select("Date"="date", "Cases" = new.cases, "Deaths"=deaths, "Hopsitalised_patients"=hosp.cases, "Mechanicaly_ventilated"=MV.beds, "First_vaccine_dose"=vaccine.first, "Second_vaccine_dose"=vaccine.second, vaccine.complete)

##UI ####
shinyUI(dashboardPage(
  dashboardHeader(title = "UK COVID 19 Data"),
  dashboardSidebar(
    
    sidebarUserPanel("UK COVID-19 Data",
                     image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Cases", tabName="charts", icon=icon("signal")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "map",
              fluidRow(box(leafletOutput("mymap")),
                       box(leafletOutput("mymap2"))),
              fluidRow(sliderInput("DatesMerge",
                                   "Dates:",
                                   min = as.Date("2020-03-01","%Y-%m-%d"),
                                   max = as.Date("2021-08-20","%Y-%m-%d"),
                                   value=as.Date("2020-11-01"),timeFormat="%Y-%m-%d")
              )),
      tabItem(tabName= "charts", 
              fluidRow(box(plotOutput("casesDeaths"), width=12)),
              fluidRow(box(htmlOutput("hist"), width=12))),
      
      tabItem(tabName = "data",
              fluidRow(box(DT::dataTableOutput("mytable"), width = 12)))
    )
  )
))


shinyServer(function(input, output){
  
  
  #show map1 using leaflet ####
  output$mymap <- renderLeaflet({
    
    ##subset to one day using input from slider
    
    DatesMerge<-input$DatesMerge
    daily.cases.ltla <- cases.ltla.reg %>% 
      mutate(name = ifelse(name=="Cornwall and Isles of Scilly", "Cornwall", name)) %>% 
      filter(date == DatesMerge) 
    
    
    #merge covid data with map data from UK government
    #topoData2@data <- merge(topoData@data, daily.cases.ltla, by.y="name", by.x="LAD13NM", all.x=TRUE, sort.x=FALSE) %>% 
    #  arrange(OBJECTID)
    topoData2 <- topoData 
    topoData2@data <- merge(topoData@data, daily.cases.ltla,  by.x="LAD21NM", by.y="name", all.x=TRUE, sort.x=FALSE) %>% 
      arrange(OBJECTID) 
    
    mybins <- c(0,10,20, 30,40,50,80, 100,200,Inf)
    mypalette <- colorBin( palette="YlOrBr", domain=topoData2@data$new.cases, na.color="transparent", bins=mybins)
    
    mytext <- paste(
      "Local Authority: ", topoData2$LAD21NM,"<br/>", 
      "Cases: ", topoData2$new.cases, "<br/>", 
      "Deaths: ", topoData2$deaths, 
      sep="") %>%
      lapply(htmltools::HTML)
    
    
    leaflet(topoData2) %>% 
      addProviderTiles("Thunderforest.Pioneer") %>% 
      setView(lat=54.5, lng=-3.8 , zoom=5) %>%
      addPolygons( 
        fillColor = ~mypalette(new.cases), 
        stroke=TRUE, 
        fillOpacity = 0.9, 
        color="white", 
        weight=0.3,
        label = mytext,
        labelOptions = labelOptions( 
          style = list("font-weight" = "normal", padding = "3px 8px"), 
          textsize = "13px", 
          direction = "auto"
        )
      ) %>%
      addLegend( pal=mypalette, values=~new.cases, opacity=0.9, title = "Cases", position = "bottomleft" )
  })
  
  
  #map2 using leaflet####
  output$mymap2 <- renderLeaflet({
    
    DatesMerge<-input$DatesMerge
    topoData2 <- topoData 
    
    ##subset to one day
    daily.cases.ltla <- cases.ltla.reg %>% 
      mutate(name = ifelse(name=="Cornwall and Isles of Scilly", "Cornwall", name)) %>% 
      filter(date == DatesMerge) 
    
    topoData2@data <- merge(topoData@data, daily.cases.ltla,  by.x="LAD21NM", by.y="name", all.x=TRUE, sort.x=FALSE) %>% 
      arrange(OBJECTID) 
    
    mybins2 <- c(0,1,2,3,4,5,Inf)
    mypalette2 <- colorBin( palette="YlOrBr", domain=topoData2@data$deaths, na.color="transparent", bins=mybins2)
    
    mytext <- paste(
      "Local Authority: ", topoData2$LAD21NM,"<br/>", 
      "Cases: ", topoData2$new.cases, "<br/>", 
      "Deaths: ", topoData2$deaths, 
      sep="") %>%
      lapply(htmltools::HTML)
    
    
    #merge covid data with map data
    #topoData2@data <- merge(topoData@data, daily.cases.ltla, by.y="name", by.x="LAD13NM", all.x=TRUE, sort.x=FALSE) %>% 
    #  arrange(OBJECTID)
    topoData2@data <- merge(topoData@data, daily.cases.ltla,  by.x="LAD21NM", by.y="name", all.x=TRUE, sort.x=FALSE) %>% 
      arrange(OBJECTID) 
    
    leaflet(topoData2) %>% 
      addProviderTiles("Thunderforest.Pioneer") %>% 
      setView(lat=54.5, lng=-3.8 , zoom=5) %>%
      addPolygons( 
        fillColor = ~mypalette2(deaths), 
        stroke=TRUE, 
        fillOpacity = 0.9, 
        color="white", 
        weight=0.3,
        label = mytext,
        labelOptions = labelOptions( 
          style = list("font-weight" = "normal", padding = "3px 8px"), 
          textsize = "13px", 
          direction = "auto"
        )
      ) %>%
      addLegend( pal=mypalette2, values=~new.cases, opacity=0.9, title = "Deaths", position = "bottomleft" )
  })
  
  #cases plot ####
  output$casesDeaths <- renderPlot({
    
    cases.reg2 <- cases.reg %>%
      arrange(date) %>% 
      mutate(date_case = date(date))
    
    cases.reg3 <- gather(data=cases.reg2, key="Case_type", value="cases", new.cases, deaths) 
    
    ggplot(cases.reg3, aes(x = date_case, y = cases, fill = Case_type)) +
      geom_col(alpha = 0.5, position = "dodge") +
      scale_fill_brewer(palette = "Dark2") +
      theme(axis.text.x = element_text(angle = 50, hjust = 1)) +
      scale_x_date("Date", date_labels = "%b, %Y", breaks = "month")+
      scale_y_continuous("Number of people")
    #could make 2nd y scale and make line plot graph of deaths insread of bar graph
    #better labelling 
    #needs title plot 
  })
  
  #Hospitalisations ####
  
  output$hist <- renderGvis({
    
    hosp.reg2 <- cases.reg %>%
      rename("Mechanically_ventilated" ="MV.beds") %>% 
      arrange(date) %>% 
      mutate(date_case = date(date)) %>% 
      mutate(Diff = hosp.cases - lag(hosp.cases)) %>% 
      mutate(No_mechanically_ventilated = hosp.cases - Mechanically_ventilated) 
    
    gvisSteppedAreaChart(hosp.reg2, xvar="date_case", yvar=c("Mechanically_ventilated", "No_mechanically_ventilated"),
                         options=list(isStacked=TRUE, 
                                      title="Hospital Admissions: Mechanically ventilated vs non-mechanical ventilated", 
                                      titlePosition='out',
                                      vAxis= "{title: 'Number of patients'}",
                                      hAxis="{title:'Date', slantedText:'true',slantedTextAngle:45}",
                                      legend="{position: 'bottom', textStyle: {color: 'blue', fontSize: 16}}",
                                      titleTextStyle="{color:'black',fontName:'Courier',fontSize:14}"
                         ))
  })
  
  
  # show data using DataTable
  output$mytable <- DT::renderDataTable({
    data_table 
  })
  
  
})

shinyApp(ui, server, global)