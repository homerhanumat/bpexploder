#' D# Exploding Boxplots
#'
#' Produce an svg element showing boxplots that explode upon mouse-click
#' into jittered individual-value plots.
#'
#' @param data A data frame containing all variables involved in the plot.
#' @param settings A list with the foloowing elements:
#' \itemize{
#'  \item{"groupVar"}{character vector of length one, giving name of goruping variable.
#'  (Leave NULL or omit for no grouping.)}
#'  \item{"levels"}{character vector of values of groupVar.  Leave NULL or omit to get
#'  levels in alphabetical order.}
#'  \item{"levelLabels"}{Character vector giving custom labels for levels of goruping variable.}
#'  \item{"levelColors"}{Character vector giving custom colors for boxes.}
#'  \item{"yVar"}{Character vector of length one, specifying the numerical variable to plot.}
#'  \item{"yAxisLabel"}{Character vector of length one.}
#'  \item{"xAxisLabel"}{Character vector of length one.}
#'  \item{"tipText"}{List of character vectors.  Names are variables to show in the tooltips, values
#'  are the labels to denote these variables.}
#'  \item{"referenceId"}{Character vector; id attribute of an HTML tag.  Offset-width of this element
#'  is used to set width of the svg.  Defaults to the grandparent element.
#'  grandparent element.}
#'  \item{"relativeWidth"}{Number between 0 and 1, svg-width is this number multplied by the
#'  offset-width of the reference element.}
#' }
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.  Suggest to leave NULL.
#' @param elementId id of element ot contain widget.  Should be left NULL.
#' @import htmlwidgets
#'
#' @export
bpexploder <- function(data,
                       settings = list(
                         groupVar = NULL,
                         levels = NULL,
                         levelLabels = NULL,
                         levelColors = NULL,
                         yVar,
                         yAxisLabel = NULL,
                         xAxisLabel = NULL,
                         tipText = NULL,
                         referenceId = NULL,
                         relativeWidth = 1
                       ),
                       width = NULL, height = NULL, elementId = NULL) {

  ##############################################################
  ## gently catch a few of the more common entry-errors
  #############################################################

  if ( is.null(settings$yVar) ) {
    stop("yVar must be set.")
  }

  yVar <- settings$yVar

  if ( !(yVar %in% names(data)) ) {
    stop("yVar must be one of the numeric variables in the data.")
  }

  if ( !is.numeric(data[, yVar]) ) {
    stop("yVar must be one of the numeric variables in the data.")
  }

  grouping <- !is.null(settings$groupVar)

  if ( grouping ) {
    groupVarName <- settings$groupVar
  } else {
    settings$groupVar <- NULL
  }

  if ( !grouping & !is.null(settings$levels) ) {
    stop("grouping-variable levels specified when no grouping variable set")
  }

  if ( !grouping & !is.null(settings$xAxisLabel) ) {
    if ( nchar(settings$xAxisLabel) > 0 ){
      warning("x-axis label specified when no grouping variable set")
    }
  }

  if ( grouping ) {
    if ( !(groupVarName %in% names(data)) ) {
      stop("Grouping variable must be a categorical variable in the data.")
    }
  }

  if ( grouping ) {
    groupVar <- data[, groupVarName]
    ref <- sort(unique(groupVar))
  }

  if ( grouping & is.null(settings$levels) ) {
    settings$levels <- ref
  }

  if ( grouping ) {
    if ( !all(sort(unique(settings$levels)) == ref) ) {
      stop("Levels must be same as values of the grouping variable.")
    }
  }

  if ( grouping & !is.null(settings$levelLabels) ) {
    len <- length(settings$levelLabels)
    reflen <- length(ref)
    if ( len != reflen ) {
      stop("Number of level-labels must equal number of distinct values of the grouping variable.")
    }
  }

  if ( grouping & !is.null(settings$levelColors) ) {
    len <- length(settings$levelColors)
    reflen <- length(ref)
    if ( len != reflen ) {
      stop("Number of level-colors must equal number of distinct values of the grouping variable.")
    }
  }

  tooltipping <- !is.null(settings$tipText)
  if ( tooltipping ) tipText <- settings$tipText

  if ( tooltipping ) {
    tipVars <- names(tipText)
    if ( !all(tipVars %in% names(data)) ) {
      stop("One or more of the tool-tip variables is not in the data.")
    }
  }

  ####################################################################
  # forward options using plotInfo
  ####################################################################

  plotInfo = list(
    data = data,
    settings = settings
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'bpexploder',
    plotInfo,
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
