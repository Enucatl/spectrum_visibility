---
---

$ ->
    window.polychromatic_visibility = (m, design_energy, energy) ->
        2 / Math.PI * Math.abs(
            Math.pow(Math.sin(
                Math.PI / 2 * design_energy / energy
            ), 2) *
            Math.sin(
                m * Math.PI / 2 * design_energy / energy
            )
        )
