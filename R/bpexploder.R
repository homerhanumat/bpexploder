#' D3 Exploding Boxplots
#'
#' Produce an svg element showing boxplots that explode upon mouse-click
#' into jittered individual-value plots.
#'
#' @param data A data frame containing all variables involved in the plot.
#' @param settings A list with the following elements:
#' \itemize{
#'  \item{\code{groupVar}}{ Character vector of length one setting name of grouping variable.
#'  (Leave NULL or omit for no grouping.)}
#'  \item{\code{levels}}{ Character vector of values of groupVar.  Leave NULL or omit to render
#'  levels in alphabetical order.}
#'  \item{\code{levelLabels}}{ Character vector setting custom labels for levels
#'  of grouping variable.}
#'  \item{\code{levelColors}}{ Character vector setting custom colors for boxes.}
#'  \item{\code{yVar}}{ Character vector of length one, specifying the numerical variable to plot.}
#'  \item{\code{yAxisLabel}}{ Character vector of length one.}
#'  \item{\code{xAxisLabel}}{ Character vector of length one.}
#'  \item{\code{tipText}}{ List of character vectors.  Names are variables to show in the
#'  tooltips, values are the labels to denote these variables.}
#'  \item{\code{referenceId}}{ Character vector; id attribute of an HTML tag.  Offset-width of
#'  this element is used to set width of the svg.  Defaults to the grandparent element.}
#'  \item{\code{relativeWidth}}{ Number between 0 and 1. The svg-width is this number
#'  multplied by the offset-width of the reference element.}
#'  \item{\code{align}}{ alignment of htmlwidget within containing div. Defaults to
#'  "center"; other values are "left" and "right".}
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
                         relativeWidth = 1,
                         align = "center"
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

  if ( is.null(settings$align) ) {
    settings$align <- "center"
  } else {
    if ( !(settings$align %in% c("center", "left", "right")) ) {
      stop("alignment is center`, 'left' or 'right'")
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
