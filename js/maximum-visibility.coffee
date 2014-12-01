---
---

$ ->
    window.maximum_visibility = (spectrum_file, design_energy, m) ->
        d3.csv spectrum_file,
            (d) ->
                energy: +d.energy
                photons: +d.photons
            (error, data) ->
                if error?
                    console.warn error
                    return
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
                total_photons = data.reduce(
                    (total, datum) ->
                        total + datum.photons
                    , 0)
                visibility = with_visibility.reduce(
                    (total, datum) ->
                        total + datum.visibility * datum.photons / total_photons
                    , 0) * 100
                $("#max-vis").text "maximum visibility with the above settings: #{visibility.toFixed(1)} %"
