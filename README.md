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

Set-up:

``` r
library(bpexploder)
set.seed(5437)  # one way to avoid .Random.Seed warning from widgetId creation
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

Credits
-------

The JavaScript library is based on Mathieu Caule's [D3 Exploding Boxplots](https://mcaule.github.io/d3_exploding_boxplot/), which I have modified slightly and updated for D3 Version 4. The tool-tips were originally developed by [Justin Palmer](https://github.com/Caged) and were updated by [Dave Gotz](https://github.com/VACLab/d3-tip). I modified the tip-function a bit.
