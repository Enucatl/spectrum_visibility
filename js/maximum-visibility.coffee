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
            bottom: 0.15 * height
            right: 0.05 * width
        .x_value (d) -> d.energy
        .y_value (d) -> d.visibility
    axes = new d3.chart.Axes()
        .x_title "energy (keV)"
    axes.x_scale plot.x_scale()
    axes.y_scale plot.y_scale()

    window.maximum_visibility = (spectrum_file, design_energy, m) ->
        d3.csv spectrum_file,
            (d) ->
                energy: parseFloat(d.energy)
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
                    ) * d.photons / total_photons else 0
                visibility = with_visibility.reduce(
                    (total, datum) ->
                        total + datum.visibility
                    , 0) * 100

                energy_interval = with_visibility[1].energy - with_visibility[0].energy
                plot.x_scale()
                    .domain d3.extent with_visibility, plot.x_value()
                plot.y_scale()
                    .domain d3.extent with_visibility, plot.y_value()

                axes.y_title "contribution to visibility / #{energy_interval.toFixed(1)} (keV)"

                d3.select "#visibility-plot"
                    .datum with_visibility
                    .call plot.draw

                console.log axes.x_scale().domain()
                console.log axes.x_scale().range()

                axes
                    .y_axis()
                    .tickFormat d3.format ".1%"

                d3.select "#visibility-plot"
                    .select "svg"
                    .select "g"
                    .data [1]
                    .call axes.draw

                $("#max-vis").text "#{visibility.toFixed(1)} %"
