---
---
$ ->
    maximum_visibility = (data, design_energy, m) ->
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
            ) else 0
        console.log "with_visibility", with_visibility
        total_photons = data.reduce(
            (total, datum) ->
                total + datum.photons
            , 0)
        visibility = with_visibility.reduce(
            (total, datum) ->
                total + datum.visibility * datum.photons / total_photons
            , 0) * 100
        $("#max-vis").text "maximum visibility: #{visibility.toFixed(1)} %"

    d3.csv "data/caro.26kVp.csv", 
        (d) ->
            energy: +d.energy
            photons: +d.photons
        (error, data) ->
            if error?
                console.warn error
                return
            design_energy = 20
            m = 1
            maximum_visibility data, design_energy, m
