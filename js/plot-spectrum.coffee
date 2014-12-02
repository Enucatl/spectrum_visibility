---
---

$ ->
    factor = 0.618
    width = $("#spectrum-plot").width()
    height = factor * width
    plot = new d3.chart.Bar()
        .width width
        .height height
        .margin
            left: 0.10 * width
            top: 0
            bottom: 0.10 * height
            right: 0.05 * width
        .x_value (d) -> d.energy
        .y_value (d) -> d.photons
    axes = new d3.chart.Axes()
    axes.x_scale plot.x_scale()
    axes.y_scale plot.y_scale()

    update_plot = (spectrum_file) ->
        d3.csv spectrum_file, (error, json) ->
            if error?
                console.warn error
                return
            
            total_photons = json.reduce((total, datum) ->
                    total + parseFloat(datum.photons)
                , 0)

            data = json.map (d) ->
                energy: parseInt(d.energy)
                photons: parseFloat(d.photons) / total_photons

            plot.x_scale()
                .domain d3.extent data, plot.x_value()
            plot.y_scale()
                .domain d3.extent data, plot.y_value()

            d3.select "#spectrum-plot"
                .datum data
                .call plot.draw

            console.log axes.x_scale().domain()
            console.log axes.x_scale().range()

            axes
                .y_axis()
                .tickFormat d3.format ".1%"

            d3.select "#spectrum-plot"
                .select "svg"
                .select "g"
                .datum 1
                .call axes.draw

    $("input#select-spectrum").change ->
        update_plot $("input#select-spectrum").val()

    update_plot $("input#select-spectrum").val()
