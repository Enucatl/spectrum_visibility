---
---

$ ->
    placeholder = "#design-energy-plot"
    factor = 0.618
    width = $(placeholder).width()
    height = factor * width
    plot = new d3.chart.Bar()
        .width width
        .height height
        .margin
            left: 0.10 * width
            top: 0
            bottom: 0.15 * height
            right: 0.05 * width
        .x_value (d) -> d.design_energy
        .y_value (d) -> d.visibility
    axes = new d3.chart.Axes()
        .x_title "design energy (keV)"
    axes.x_scale plot.x_scale()
    axes.y_scale plot.y_scale()

    design_energy_plot = (spectrum_file, m) ->
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

                design_energy = data.map (d) ->
                    design_energy: d.energy
                    visibility: data.map (e) ->
                            if e.photons then window.polychromatic_visibility(m, d.energy, e.energy) * e.photons / total_photons else 0
                        .reduce((total, datum) ->
                                total + datum
                            , 0)

                energy_interval = design_energy[1].design_energy - design_energy[0].design_energy
                plot.x_scale()
                    .domain d3.extent design_energy, plot.x_value()
                plot.y_scale()
                    .domain d3.extent design_energy, plot.y_value()

                axes.y_title "visibility"

                d3.select placeholder
                    .datum design_energy
                    .call plot.draw

                axes
                    .y_axis()
                    .tickFormat d3.format ".1%"

                d3.select placeholder
                    .select "svg"
                    .select "g"
                    .data [1]
                    .call axes.draw

    update_design_energy = ->
        spectrum_file = $("input#select-spectrum").val()
        talbot_order = +$("input#talbot-order").val()
        design_energy_plot spectrum_file, talbot_order 
        $("#talbot-order-title").text talbot_order
    $("input#select-spectrum").change update_design_energy
    $("input#talbot-order").change update_design_energy
    update_design_energy()
