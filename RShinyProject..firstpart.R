
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

# --------------------------------------Server ------------------------------------------------------------------

server <- function(input, output) {

  filtered_data <- reactive({

    vehicles %>%
      filter(State %in% input$state,
             County %in% input$county,
             Electric.Vehicle.Type %in% input$make)

  })


  observeEvent(input$state, {
    counties <- unique(filter(vehicles,
                              State == input$state)$County)

    # Automatically select the first county in the dropdown
    default_county <- if (length(counties) > 0) counties[1] else NULL
    updateSelectInput(inputId = "county",
                      choices = counties,
                      selected = default_county)
  })

  output$make <- renderUI({
    selects <- unique(filtered_data()$Electric.Vehicle.Type)
    selectInput("make", "Make", choices = selects)
  })

#Add plot


}


