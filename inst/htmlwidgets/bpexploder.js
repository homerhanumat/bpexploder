HTMLWidgets.widget({

  name: 'bpexploder',

  type: 'output',

  factory: function(el, width, height) {

            // responsivefy modified just a bit from:
    // https://gist.github.com/soykje/ec2fc326830355104c89cd50bf1fa192
    function responsivefy(svg, referenceId) {
      // get container + svg aspect ratio
      var container = d3.select(svg.node().parentNode),
        width = parseInt(svg.attr("data-width")),
        height = parseInt(svg.attr("data-height")),
        aspect = width / height;

      // add viewBox and preserveAspectRatio properties,
      // and call resize so that svg resizes on inital page load
      svg.attr("viewBox", "0 0 " + width + " " + height)
        .attr("preserveAspectRatio", "xMinYMid")
        .call(resize);

      // to register multiple listeners for same event type,
      // you need to add namespace, i.e., 'click.foo'
      // necessary if you call invoke this function for multiple svgs
      // api docs: https://github.com/mbostock/d3/wiki/Selections#on
      d3.select(window).on("resize." + container.attr("id"), resize);

      // get width of container and resize svg to fit it
      function resize() {
        var targetWidth;
        if ( referenceId ) {
          var measure = document.querySelector("#" + referenceId);
          targetWidth = measure.offsetWidth;
        } else {
          var grandparent = container.node().parentNode;
          targetWidth = grandparent.offsetWidth;
        }
        svg.attr("width", targetWidth);
        var targetHeight = Math.round(targetWidth / aspect);
        svg.attr("height", targetHeight);
        container.style("width", Math.round(targetWidth) + "px");
        container.style("height", Math.round(targetHeight) + "px");
        container.attr("width", targetWidth);
        container.attr("height", targetHeight);
        var firstRect = svg.select("rect");
        firstRect.attr("width", targetWidth);
        firstRect.attr("height", targetHeight);
      }
    }

    return {

      renderValue: function(x) {

    var data = HTMLWidgets.dataframeToD3(x.data);

    var settings = x.settings;

      var groupVar = settings.groupVar,
        levels = settings.levels,
        levelLabels = settings.levelLabels,
        levelColors = settings.levelColors,
        yVar = settings.yVar,
        yAxisLabel = settings.yAxisLabel,
        xAxisLabel = settings.xAxisLabel,
        tipText = settings.tipText,
        referenceId = settings.referenceId;


      if ( !levelLabels ) {
        levelLabels = levels;
      }

      if ( !yAxisLabel ) {
        yAxisLabel = yVar;
      }

      if ( !xAxisLabel ) {
        xAxisLabel = groupVar;
      }

      var nested = d3.nest()
        .key(d => d[groupVar])
        .entries(data);

      var processedData = [];

      function pullData(d, index) {
        var caseInfo = {
          [yAxisLabel]: parseFloat(d[yVar]),
          [xAxisLabel]: levelLabels[index]
        };
        if ( tipText ) caseInfo.t = tipText;
        return caseInfo;
      }

      if ( levels ) {
        levels.forEach(function(level, index){
          var singleGroup = nested.find(function(x) {
            return(x.key === level);
          }).values
            .map(function pullData(d) {
              var caseInfo = {
                [yAxisLabel]: parseFloat(d[yVar]),
                [xAxisLabel]: levelLabels[index]
              };
              if ( tipText ) {
                var tips = {};
                  for ( var key in tipText ) {
                    tips[tipText[key]] = d[key];
                }
                caseInfo.t = tips;
              }
              return caseInfo;
            });
          processedData = processedData.concat(singleGroup);
        });
      } else {
        processedData = nested[0].values.map(function pullData(d) {
          var caseInfo = {
            [yAxisLabel]: parseFloat(d[yVar]),
            [xAxisLabel]: ""
          };
          if ( tipText ) {
            var tips = {};
            for ( key in tipText ) {
              tips[tipText[key]] = d[key];
            }
            caseInfo.t = tips;
          }
          return caseInfo;
        });
      }


      processedData = processedData.filter(function(x) {
        if ( groupVar ) {
          return(x[xAxisLabel] && x[yAxisLabel]);
        } else {
          return (typeof(x[yAxisLabel]) !== "undefined");
        }

      });

      var aesthetics = {
        y: yAxisLabel
      };

      if ( levelColors ) {
        aesthetics.levelColors = levelColors;
      }

      if ( xAxisLabel ) {
        aesthetics.group = xAxisLabel;
      }

      if ( tipText ) {
        aesthetics.label = "t";
      }


      var chart = exploding_boxplot(
        processedData, aesthetics
      );

      // remove prior svg, in case in Shiny
      d3.select("#" +  el.id + " svg").remove()

      //call chart on a div
      chart("#" + el.id);
      responsivefy(d3.select("#" + el.id + " svg"), referenceId);
      },

      resize: function(width, height) {
        console.log("width " + width + " ; height " + height);

        // TODO: code to re-render the widget with a new size
        // (Cross this bridge if we come to it ...)
        //responsivefy(d3.select("#" + el.id + " svg"));


      }

    };
  }
});
