#install.packages("RSQLite")
library(RSQLite)
library(data.table)

#read.csv
csvpath = "C:/Users/Vallari/Desktop/NYC_academy/R/R_intro lectures/R_Shiny_project/Data/covidcases.csv"
dbname= "./covid.sqlite"
tblname ="UKcovidcases"

data <- fread(input=csvpath, 
              sep=",",
              header=TRUE)

##connect to database
conn <- dbConnect(drv=SQLite(), 
                  dbname=dbname)

##write table 

dbWriteTable(conn=conn, 
             name=tblname, 
             value=data)

#list tables 
dbListTables(conn)

##dbdisconnect 

dbDisconnect(conn)


