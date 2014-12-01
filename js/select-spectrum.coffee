---
---

$ ->
    $("#select-spectrum").select2(
        placeholder: "choose a spectrum"
        ajax:
            url: "data/spectra.json"
            cache: true
            results: (data, page) ->
                results: data
        initSelection: (element, callback) ->
            id = $(element).val()
            if id?
                $.ajax "data/spectra.json" 
                    .done (data) ->
                        with_id = data.filter (d) ->
                            d.id is id
                        callback(with_id[0])
    )
