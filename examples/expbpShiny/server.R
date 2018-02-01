library(shiny)
library(bpexploder)

shinyServer(function(input, output) {

  output$explodingPlot <- renderBpexploder({
    tipText <- list(input$yvar)
    names(tipText) <- input$yvar
    bpexploder(data = iris,
               settings = list(
                 groupVar = "Species",
                 levels = levels(iris$Species),
                 yVar = input$yvar,
                 relativeWidth = 0.8,
                 tipText = tipText))
  })

})


