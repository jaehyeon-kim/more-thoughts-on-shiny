library(magrittr)
library(DT)
library(highcharter)
library(plotly)

library(shiny)

library(promises)
library(future)
plan(multiprocess, workers = 100)

tab <- tabPanel(
    title = 'Demo',
    fluidPage(
      fluidRow(
        column(4,
               actionButton('dt', 'update')),
        column(4,
               actionButton('highchart', 'update')),
        column(4,
               actionButton('plotly', 'update'))
      ),
      br(),
      fluidRow(
        column(4,
               dataTableOutput('dt_out')),
        column(4,
               highchartOutput('highchart_out')),
        column(4,
               plotlyOutput('plotly_out'))
      )      
    )
)

ui <- navbarPage("Async Shiny", tab)

server <- function(input, output, session) {
  
    get_iris <- function() {
      future({ Sys.sleep(2); iris[sample(1:nrow(iris), 10),] })
    }
    
    dt_df <- eventReactive(input$dt, {
        get_iris() %...>%
          datatable(options = list(
            pageLength = 5,
            lengthMenu = c(5, 10)
          ))
    })
    
    highchart_df <- eventReactive(input$highchart, {
      get_iris()
    })
    
    plotly_df <- eventReactive(input$plotly, {
      get_iris()
    })
    
    output$dt_out <- renderDataTable(dt_df())
    
    output$highchart_out <- renderHighchart({
      highchart_df() %...>% 
        hchart('scatter', hcaes(x = 'Sepal.Length', y = 'Sepal.Width', group = 'Species')) %...>%
        hc_title(text = 'Iris Scatter')
      })

    output$plotly_out <- renderPlotly({
      plotly_df() %...>%
        plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, z = ~Petal.Length, color = ~Species)
    })
}

shinyApp(ui = ui, server = server)

