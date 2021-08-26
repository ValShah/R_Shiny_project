
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
                    fluidRow(box(DT::dataTableOutput("mytable"), width = 12))), 
            tabItem(tabName = 'conclusion',
                    #start
                    
                    fluidRow(
                        HTML('<H1><b>Conclusion</b></H1><br>
                     ')
                    ),              
                    
                    fluidRow(
                        box(
                            title = "Conclusion", background = "olive", solidHeader = TRUE, width=12,
                            HTML('<li>In the UK, compared to the early part of the pandemic, the case counts and deaths from COVID 19 now seems to be reduced.</li>
                         <li>This is likely to be due to significant proportion of the population who have been vaccinated or previously contracted the infection</li>
                         <li>This is also seen in the data comparing case counts and hospitalised patients.</li>
                         <br>')
                        )
                    ),
                    fluidRow(
                        HTML('<br>'),
                        box(
                            title = "Next steps", background = "green", solidHeader = TRUE, width=12,
                            HTML('<li>For further analysis, data should be broken down into different age groups.</li>
                        <li>Current hospitalisations for each area should also be compared to vaccination rates and previous infection rates for each area.</li>
                         <br>')
                        )
                    )
                    
                    
                    #end
            )
        )
        
    )
))


