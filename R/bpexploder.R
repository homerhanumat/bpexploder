#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
bpexploder <- function(data = iris,
                       settings = list(
                         groupVar = "Species",
                         levels = c("setosa", "versicolor", "virginica"),
                         levelLabels = NULL,
                         levelColors = NULL,
                         yVar = "Petal.Length",
                         yAxisLabel = "Petal Length",
                         xAxisLabel = NULL,
                         tipText = list(
                           Sepal.Length = "Sepal Length",
                           Sepal.Width = "Sepal Width",
                           Petal.Width = "Petal Width"
                         )
                       ),
                       width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = data,
    settings = settings
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'bpexploder',
    x,
    width = width,
    height = height,
    package = 'bpexploder',
    elementId = elementId
  )
}

#' Shiny bindings for bpexploder
#'
#' Output and render functions for using bpexploder within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a bpexploder
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name bpexploder-shiny
#'
#' @export
bpexploderOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'bpexploder', width, height, package = 'bpexploder')
}

#' @rdname bpexploder-shiny
#' @export
renderBpexploder <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, bpexploderOutput, env, quoted = TRUE)
}
