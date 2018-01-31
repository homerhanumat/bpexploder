Exploding Boxplots
================

A Simple Widget
---------------

`bpexploder` represents my first foray into Html Widgets for R; it renders box-plots that explode upon mouse-click into jittered individual-value plots. You have the option to configure tool-tips for the individual points.

Installation
----------------------

Install the package from Git Hub:

``` r
devtools::install_github("homerhanumat/bpexploder")
```

Usage and Examples
--------

See [the package website](https://homerhanumat.github.io/bpexploder).

Credits
-------

The JavaScript library is based on Mathieu Caule's [D3 Exploding Boxplots](https://mcaule.github.io/d3_exploding_boxplot/), which I have modified slightly and updated for D3 Version 4. The tool-tips were created by [Justin Palmer](https://github.com/Caged), updated to D3v4 by [Dave Gotz](https://github.com/VACLab/d3-tip) and tweaked slightly by myself.
