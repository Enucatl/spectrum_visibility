---
---

$ ->
    window.compute_parameters = (spectrum_file, period, design_energy, talbot_order, absorption_thickness) ->
        lambda = 1.24e-3 / design_energy  # um
        talbot_distance = talbot_order * period * period / 8 / lambda * 1e-4  # cm
        intergrating_distance = 2 * talbot_distance
        $("#intergrating-distance").text "#{intergrating_distance.toFixed(2)}"

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
                d3.csv "data/au.csv",
                    (d) ->
                        energy: parseFloat(d.energy)
                        delta: parseFloat(d.delta)
                        beta: parseFloat(d.beta)
                        atlen: parseFloat(d.atlen)
                    (error, material_data) ->
                        if error?
                            console.warn error
                            return
                        bisect = d3.bisector((d) -> d.energy).left
                        photons_after_grating = 0
                        data.forEach (datum) ->
                            index = bisect(material_data, datum.energy)
                            atlen = material_data[index].atlen
                            photons_after_grating += datum.photons * Math.exp(-absorption_thickness * 1e-4 / atlen)

                        $("#absorption-efficiency").text "#{((1 - photons_after_grating / total_photons) * 100).toFixed(1)} %"

                        index = bisect(material_data, design_energy)
                        delta = material_data[index].delta
                        pi_shift_thickness = lambda / 2 / delta
                        $("#pishift-au").text "#{pi_shift_thickness.toFixed(1)}"
