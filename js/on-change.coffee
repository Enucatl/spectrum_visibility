---
---

$ ->
    get_values = ->
        spectrum_file = $("input#select-spectrum").val()
        talbot_order = +$("input#talbot-order").val()
        design_energy = +$("input#design-energy").val()
        period = +$("input#grating-period").val()
        absorption_thickness = +$("input#absorption-thickness").val()
        window.maximum_visibility(spectrum_file, design_energy, talbot_order)
        window.compute_parameters(spectrum_file, period, design_energy, talbot_order, absorption_thickness)
    $("input").change get_values
    get_values()
