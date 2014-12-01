---
---

$ ->
    factor = 0.618
    width = $("#visibility-plot").width()
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
        .y_value (d) -> d.visibility
    axes = new d3.chart.Axes()
    axes.x_scale plot.x_scale()
    axes.y_scale plot.y_scale()

    window.maximum_visibility = (spectrum_file, design_energy, m) ->
        d3.csv spectrum_file,
            (d) ->
                energy: parseInt(d.energy)
                photons: parseFloat(d.photons)
            (error, data) ->
                if error?
                    console.warn error
                    return
                total_photons = data.reduce(
                    (total, datum) ->
                        total + datum.photons
                    , 0)
                with_visibility = data.map (d) ->
                    energy: d.energy
                    photons: d.photons
                    visibility: if d.photons then 2 / Math.PI * Math.abs(
                        Math.pow(Math.sin(
                            Math.PI / 2 * design_energy / d.energy
                        ), 2) *
                        Math.sin(
                            m * Math.PI / 2 * design_energy / d.energy
                        )
                    ) / total_photons else 0
                visibility = with_visibility.reduce(
                    (total, datum) ->
                        total + datum.visibility * datum.photons
                    , 0) * 100

                plot.x_scale()
                    .domain d3.extent with_visibility, plot.x_value()
                plot.y_scale()
                    .domain d3.extent with_visibility, plot.y_value()

                d3.select "#visibility-plot"
                    .datum with_visibility
                    .call plot.draw

                console.log axes.x_scale().domain()
                console.log axes.x_scale().range()

                d3.select "#visibility-plot"
                    .select "svg"
                    .select "g"
                    .data [1]
                    .call axes.draw

                $("#max-vis").text "#{visibility.toFixed(1)} %"
