library(shiny)
library(shinycssloaders)
library(shinyWidgets)

driver_ids <- as.vector(sample(heetchPoints$driver_id, 60))
days <- as.vector(heetchPoints$YMD %>% unique %>% str_sort)

ui <- fluidPage(navbarPage('Geospatial analysis on Heetch Casablanca',
       setBackgroundColor("#F7FBFF"),
                           
     tabPanel('Driver speed',
              h4("This plot allows us to detect of the driver passed 60 km in
                 the city"),
              
              sidebarLayout(sidebarPanel(
                selectInput("s1", "Choose a driver id:", driver_ids),
                selectInput("s2", "Choose a date:", days),
                
              ),
                mainPanel(plotOutput('g1')%>% withSpinner(color="#0dc5c1"))
              )),
     
     
     tabPanel('Driver time of work',
              h4("This plot allows to know approximately how many hours the 
                 driver works"),
              sidebarLayout(sidebarPanel(
                selectInput("s11", "Choose a driver id:", driver_ids),
                actionButton('b11', 'apply'),
                
              ),
              mainPanel(plotOutput('g2')%>% withSpinner(color="#0dc5c1"))
              )),
     
     
     tabPanel('Rythm of work night or day',
              h4("This plot allows to know the rythm of work between night
                 and day"),
               sidebarLayout(sidebarPanel(

                selectInput("s111", "Choose a driver id:", driver_ids),
                selectInput("s222", "Choose a date:", days),
                actionButton('b111', 'apply'),
                
              ),
              mainPanel(leafletOutput('g3')%>% withSpinner(color="#0dc5c1"))
              )),
     
     tabPanel('Casablanca Facilities',
              sidebarLayout(sidebarPanel(
                h6("This plot is considerd as an overview of all casablanca 
                   facitlies "),
                
              ),
              mainPanel(leafletOutput('g4')%>% withSpinner(color="#0dc5c1"))
              )),
     
     
     tabPanel('Place the driver have been',
              sidebarLayout(sidebarPanel(
                selectInput("s1111", "Choose a driver id:", driver_ids),
                selectInput("s2222", "Choose a date:", days),
                textInput('inputId', 'name of the place', 
                          value = "Pizza Hut", 
                          width = NULL, placeholder = NULL),
                actionButton('b1111', 'apply'),
              ),
              mainPanel(leafletOutput('g5') %>% withSpinner(color="#0dc5c1"))
              )),
     
     
     tabPanel('Distance crossed each day',
              sidebarLayout(sidebarPanel(
                selectInput("s11111", "Choose a driver id:", driver_ids),
                actionButton('b11111', 'apply'),
                
              ),
              mainPanel(plotOutput('g6')%>% withSpinner(color="#0dc5c1"))
              )),
     
     
     tabPanel('Detect home',
              sidebarLayout(sidebarPanel(
                selectInput("s111111", "Choose a driver id:", driver_ids),
                selectInput("s222222", "Choose a date:", days),
                actionButton('b111111', 'apply'),
              ),
              mainPanel(leafletOutput('g7') %>% withSpinner(color="#0dc5c1"))
              )) 
     
                           )) 
  
server <- function(input, output){
  
  v1 <- reactiveValues(data = NULL)
  observeEvent(input$b1, {
    v1$data <- heetchPoints
   })
  
  
  v2 <- reactiveValues(data = NULL)
  observeEvent(input$b11, {
    v2$data <- heetchPoints
  })
  
  
  v3 <- reactiveValues(data = NULL)
  observeEvent(input$b111, {
    v3$data <- heetchPoints
  })
  
  v4 <- reactiveValues(data = NULL, place=NULL)
  observeEvent(input$b1111, {
    v4$data <- heetchPoints
    v4$place <- osmFeatures$restaurant
  })
  
  v5 <- reactiveValues(data = NULL)
  observeEvent(input$b11111, {
    v5$data <- heetchPoints
  })
  
  v6 <- reactiveValues(data = NULL)
  observeEvent(input$b111111, {
    v6$data <- heetchPoints
  })
 
  output$g1 <- renderPlot({ 
    speed_detector(heetchPoints, input$s1, input$s2)
  })
  
  output$g2 <- renderPlot({ 
    driver_time_of_woks(v2$data, input$s11)
  })
  
  output$g3 <- renderLeaflet({ 
    visulize_trace(v3$data, input$s111, input$s222)
  })
  
  output$g4 <- renderLeaflet({ 
    plot_facilities()
  })
  
  output$g5 <- renderLeaflet({ 
    have_you_been_in_this_place(input$inputId, v4$place,  v4$data, input$s1111,
                                input$s2222)  })
                               
  output$g6 <- renderPlot({ 
    driver_distance_crossed(v5$data, input$s11111)
  })
  
  output$g7 <- renderLeaflet({ 
    detect_home(v6$data, input$s11111,input$s222222)
  })
  
}


shinyApp(ui = ui, server = server) 
