
shinyUI(dashboardPage(
    dashboardHeader(title = "UK COVID 19 Data"),
    dashboardSidebar(
        
        sidebarUserPanel("UK COVID-19 Data analysis"),
        sidebarMenu(
            menuItem("Overview", tabName = "overview", icon = icon("info")),
            menuItem("Map of Cases over time", tabName = "map", icon = icon("map")),
            menuItem("Cases", tabName="charts", icon=icon("signal")),
            menuItem("Data", tabName = "data", icon = icon("database")), 
            menuItem("Conclusion", tabName = "conclusion", icon = icon("map")),
            menuItem("About", tabName = "about", icon = icon("address-card"))
            )
        ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = 'overview',fluidRow(HTML('<H1><b>Overview</b></H1><br>')),              
                    fluidRow(box(title = "Overview", background = "olive", solidHeader = TRUE, width=12,
                                 HTML('<li>In the UK, the early part of the pandemic was not associated with vaccination.</li>
                         <li>From December 2020 onwards, vaccination of the population began stratified by age starting with the most elderly and clinically vulnerable</li>
                         <li>Here we examine the relationship between cases, deaths and hospitalisation over time.</li><br>')))),
            tabItem(tabName = "map",
                    fluidRow(HTML('<H3><b>Mapped Cases vs Deaths over time</b></H3><br>')),
                    fluidRow(box(leafletOutput("mymap")),
                             box(leafletOutput("mymap2"))),
                    fluidRow(sliderInput("DatesMerge",
                                         "Dates:",
                                         min = as.Date("2020-03-01","%Y-%m-%d"),
                                         max = as.Date("2021-08-20","%Y-%m-%d"),
                                         value=as.Date("2020-11-01"),timeFormat="%Y-%m-%d")
                    )),
            tabItem(tabName= "charts", 
                    fluidRow(HTML('<H3><b>Lineplot Cases vs Deaths over time</b></H3><br>')),
                    fluidRow(box(plotOutput("casesDeaths"), width=12)),
                    fluidRow(HTML('<H3><b>Ventilated vs non ventilated patients in hospital over time</b></H3><br>')),
                    fluidRow(box(htmlOutput("hist"), width=12))),
            
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("mytable"), width = 12))), 
            tabItem(tabName = 'conclusion',fluidRow(HTML('<H1><b>Conclusion</b></H1><br>')),              
                    fluidRow(box(title = "Conclusion", background = "olive", solidHeader = TRUE, width=12,
                        HTML('<li>In the UK, compared to the early part of the pandemic, the case counts and deaths from COVID 19 now seems to be reduced.</li>
                         <li>This is likely to be due to significant proportion of the population who have been vaccinated or previously contracted the infection</li>
                         <li>This is also seen in the data comparing case counts and hospitalised patients.</li>
                         <br>'))),
                    fluidRow(HTML('<br>'),box(title = "Next steps", background = "green", solidHeader = TRUE, width=12,
                            HTML('<li>For further analysis, data should be broken down into different age groups.</li>
                        <li>Current hospitalisations for each area should also be compared to vaccination rates and previous infection rates for each area.</li><br>')))), 
            
            
            tabItem(tabName = 'about',
                    fluidRow(HTML('<H1><b>Data and Information sources</b></H1><DIV STYLE="background-color:#808080; height:2px; width:100%;"><br>')),
                    fluidRow(box(style = "background-color:#FFFFFF;",width=8,HTML('<br>
                  <H3>Sources</H3><br>
                  <li>UK COVID-19 data via API <a href="https://coronavirus.data.gov.uk/details/developers-guide">: See link</a></li>
                  <li>Local authority geomapping data from <a href="https://www.geoportal.statistics.gov.uk/datasets/local-authority-districts-may-2021-uk-buc/explore?location=54.650000%2C-3.250000%2C6.32">: See link</a></li>
                  ')
                        )
                    )
                    
                    
                    #end
            )
            
            
            
        )
        
    )
))


