---
---

$ ->
    factor = 0.618
    width = $("input#spectrum-plot").width()
    height = factor * width
    plot = new d3.chart.Bar()
        .width width
        .height height
        .margin
            left: 0
            top: 0
            bottom: 0
            right: 0
        .x_value (d) -> d.energy
        .y_value (d) -> d.photons
    axes = new d3.chart.Axes()
        .x_scale plot.x_scale()
        .y_scale plot.y_scale()

    update_plot = (spectrum_file) ->
        d3.csv spectrum_file, (error, json) ->
            if error?
                console.warn error
                return
            plot.x_scale()
                .domain d3.extent json, plot.x_value()
            plot.y_scale()
                .domain d3.extent json, plot.y_value()

            d3.select "#spectrum-plot"
                .datum json
                .call plot.draw

            d3.select "#spectrum-plot"
                .select "svg"
                .select "g"
                .datum 1
                .call axes.draw

    $("input#select-spectrum").change ->
        update_plot $("input#select-spectrum").val()

    update_plot $("input#select-spectrum").val()
