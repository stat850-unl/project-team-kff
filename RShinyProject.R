
# Load libraries
library(shiny)
library(tidyverse)
library(leaflet)

# Load data
url <- "https://data.wa.gov/api/views/f6w7-q2d2/rows.csv?accessType=DOWNLOAD"
vehicles <- read.csv(url)

# ------------------------------------UI ----------------------------------------------------------------------

# Define UI for the application
ui <- fluidPage(

  # Application title
  titlePanel("Vehicle Explorer"),

  #Sidebar
  sidebarLayout(
    sidebarPanel(

      selectInput('state',
                  'State',
                  choices = sort(unique(vehicles$State)),
                  selected = 'WA'),  # Default value for state

      selectInput('county',
                  'County',
                  choices = sort(unique(vehicles$County)),
                  selected = 'King'),  # Default value for county
      h2('Select Electric Vehicle Type'),

      # UI Section
      selectInput("make", "Makes", choices = unique(vehicles$Electric.Vehicle.Type), multiple = TRUE, selected = c("Battery Electric Vehicle (BEV)", "Plug-in Hybrid Electric Vehicle (PHEV)"))

    ),

    # Main panel


    mainPanel(
      tabsetPanel(
        tabPanel("Plot1", plotOutput('vehicle_plot2')),

        tabPanel("Plot2", plotOutput("vehicle_plot")),

        tabPanel("Plot3", plotOutput("vehicle_plot3")),

        tabPanel("Plot4", plotOutput("vehicle_plot4"))
      )
    )
  )
)


