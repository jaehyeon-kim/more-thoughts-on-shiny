library(magrittr)
library(DT)
library(highcharter)

library(shiny)

library(promises)
library(future)
plan(multiprocess, workers = 100)

tab <- tabPanel(
    title = 'Demo',
    fluidPage(
      fluidRow(
        column(6,
               actionButton('dt', 'update')),
        column(6,
               actionButton('chart', 'update'))
      ),
      br(),
      fluidRow(
        column(6,
               dataTableOutput('dt_out')),
        column(6,
               highchartOutput('chart_out'))
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
    
    output$dt_out <- renderDataTable(dt_df())
    
    plot_df <- eventReactive(input$chart, {
      get_iris()
    })

    output$chart_out <- renderHighchart({
      plot_df() %...>% 
        hchart('scatter', hcaes(x = Sepal.Length, y = Sepal.Width, group = Species)) %...>%
        hc_title(text = 'Iris Scatter')
      })
}

shinyApp(ui = ui, server = server)

