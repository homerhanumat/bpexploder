Exploding Boxplots
================

A Simple Widget
---------------

`bpexploder` represents my first foray into Html Widgets for R; it renders box-plots that explode upon mouse-click into jittered individual-value plots. You have the option to configure tool-tips for the individual points.

Installation and Usage
----------------------

Install the package from Git Hub:

``` r
devtools::install_github("homerhanumat/bpexploder")
```

Call the function with hello-world defaults for the `iris` data:

``` r
bpexploder()
```

Click to explode boxes, double-click to restore.

Settings
--------

`bpexploder` provides modest options for customization, as illustrated in the following example:

``` r
bpexploder(data = chickwts,
          settings = list(
            yVar = "weight",
            # default NULL makes one plot for yVar
            groupVar = "feed",
            levels = levels(with(chickwts,
                                 reorder(feed, weight, median))),
            # you could adjust the group lables ...
            levelLabels = NULL,
            # ... and the colors for each group:
            levelColors = NULL,
            yAxisLabel = "6-week weight (grams)",
            xAxisLabel = "type of feed",
            tipText = list(
              # as many os you like of:
              # variableName = "desired tool-tip label"
              # leave tipText at NULL for no tips
              weight = "weight")
            )
          )
```

Sizing
------

By default the box-plot chart sizes itself as the offset-width of its grandparent node in the HTML DOM. For some layout, this might not be what you want. In that case you may direct `epexploder()` to make the width of the chart track the offset-width of an existing DOM element. For example, if paragraphs in your document have the desired width, then create an empty paragraph in your markdown like this:

    <p id="reference"></p>

Then call `bpexploder()` with the `referenceId` setting:

``` r
bpexploder(data = iris,
          settings = list(
            groupVar = "Species",
            levels = levels(iris$Species),
            yVar = "Petal.Length",
            referenceId = "reference"
            )
          )
```

Known Issues
------------

-   In the Leonids theme from the `prettydoc` R Markdown package, tooltips are not visible.
-   When `htmlwidgets::createWidget()` makes a widget it gives it a random Id number. For some reason this can result in spurious warnings concerning the hidden varible `.Random.Seed`. To work around this, set a seed in the `setup` chunk of your R Markdown document, e.g.:

    ``` r
    library(bpexploder)
    set.seed(5437)  # one way to avoid .Random.Seed warning from widgetId creation
    ```

Credits
-------

The JavaScript library is based on Mathieu Caule's [D3 Exploding Boxplots](https://mcaule.github.io/d3_exploding_boxplot/), which I have modified slightly and updated for D3 Version 4. The tool-tips were created by [Justin Palmer](https://github.com/Caged), updated to D3v4 by [Dave Gotz](https://github.com/VACLab/d3-tip) and tweaked slightly by myself.
