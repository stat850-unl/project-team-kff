
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


  Funmibi UNL: output$vehicle_plot <- renderPlot({
    filtered_data() %>%
      ggplot(aes(x = Make, y = Electric.Range, fill = Make)) +
      geom_boxplot() +
      labs(title = "Electric Range by Electric Vehicle Make", x = "Electric Vehicle Make", y = "Electric Range") +
      theme_minimal() +
      guides(fill = FALSE)

  })
  output$vehicle_plot2 <- renderPlot({
    filtered_data() %>%
      ggplot(aes(x = Model.Year, y = Electric.Range, fill = Model.Year)) +
      geom_bar(stat = "identity") +
      labs(title = "Electric Range by Electric Vehicle Model Year", x = "Electric Vehicle Model Year", y = "Electric Range")
  })

  output$vehicle_plot3 <- renderPlot({
    filtered_data() %>%
      ggplot(aes(x = Make, fill = Electric.Vehicle.Type)) +
      geom_bar(color = "black") +
      labs(title = "Top Makes by Electric Vehicle Type", x = "Make", y = "Count") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      scale_fill_manual(values = c("orange", "brown"))
  })

  output$vehicle_plot4 <- renderPlot({
    filtered_data() %>%
      ggplot(aes(x = Clean.Alternative.Fuel.Vehicle..CAFV..Eligibility, fill = Electric.Vehicle.Type)) +
      geom_bar(color = "black") +
      labs(title = "Clean Alternative Fuel Vehicle Eligibility by Electric Vehicle Type", x = "Clean Alternative Fuel Vehicle Eligibility", y = "Count") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      scale_fill_manual(values = c("orange", "brown"))
  })

}

shinyApp(ui = ui, server = server)


