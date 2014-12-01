---
---

$ ->
    get_values = ->
        spectrum_file = $("input#select-spectrum").val()
        talbot_order = +$("input#talbot_order").val()
        design_energy = +$("input#design_energy").val()
        window.maximum_visibility(spectrum_file, design_energy, talbot_order)
    $("input").change get_values
    get_values()
