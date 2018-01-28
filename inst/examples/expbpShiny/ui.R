library(shiny)
library(bpexploder)

# Define UI for application that plots random distributions
shinyUI(fluidPage(

  # Application title
  titlePanel("Exploding Boxplots!"),

  # Sidebar with a slider input for number of observations
  sidebarLayout(
    sidebarPanel(
      selectInput("yvar", label = "y-variable:",
                  choices = c("Sepal.Width", "Sepal.Length",
                              "Petal.Width", "Petal.Length"),
                  selected = "Sepal.Width")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      bpexploderOutput("explodingPlot")
    )
  )
))
