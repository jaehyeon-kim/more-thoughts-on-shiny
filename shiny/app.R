library(magrittr)
library(DT)
library(highcharter)

library(shiny)

library(promises)
library(future)
plan(multiprocess, workers = 100)

ui <- fluidPage(
    
    titlePanel("Shiny Test"),
    
    fluidRow(
        column(2,
               actionButton('iris', 'update')),
        column(2,
               actionButton('plot', 'update'),
               offset = 3)
    ),
    fluidRow(
        column(5,
               dataTableOutput('iris_out')),
        column(5,
               highchartOutput('plot_out'))
    )
)

server <- function(input, output, session) {
    
    dt_df <- eventReactive(input$iris, {
        future({ Sys.sleep(2); iris[sample(1:nrow(iris), 10),] })
    })
    
    output$iris_out <- withProgress({
      renderDataTable(dt_df())
    })
    
    plot_df <- eventReactive(input$iris, {
      future({ Sys.sleep(2); iris[sample(1:nrow(iris), 10),] })
    })

    output$plot_out <- withProgress({renderHighchart({
      plot_df() %...>% 
        hchart('scatter', hcaes(x = Sepal.Length, y = Sepal.Width, group = Species))
      })
    })
}

shinyApp(ui = ui, server = server)

