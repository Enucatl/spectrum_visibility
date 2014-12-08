---
---

$ ->
    placeholder = "#talbot-order-table"
    talbot_order_table = (spectrum_file, design_energy) ->
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
                talbot_orders = [1, 3, 5, 7]
                talbot_order = talbot_orders.map (m) ->
                    order: m
                    visibility: data.map (e) ->
                            if e.photons then window.polychromatic_visibility(m, design_energy, e.energy) * e.photons / total_photons else 0
                        .reduce((total, datum) ->
                                total + datum
                            , 0)

                rows = d3.select placeholder
                    .select "tbody"
                    .selectAll "tr"
                    .data talbot_order

                rows.enter()   
                    .append "tr"

                cells = rows
                    .selectAll "td"
                    .data (d) -> [d.order, (100 * d.visibility).toFixed(1)]

                cells.enter()
                    .append "td"

                cells
                    .classed "text-center", true
                    .text (d) -> d

                cells.exit().remove()

                rows.exit().remove()

    update_talbot_order = ->
        spectrum_file = $("input#select-spectrum").val()
        design_energy = +$("input#design-energy").val()
        talbot_order_table spectrum_file, design_energy 
    $("input#select-spectrum").change update_talbot_order
    $("input#design-energy").change update_talbot_order
    update_talbot_order()
