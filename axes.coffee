class d3.chart.Axes extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.x_axis = d3.svg.axis()
        @accessors.y_axis = d3.svg.axis()
        super

    _draw: (element, data, i) ->
        #
        # element should be the big group inside the svg already translated
        # with the margins to avoid code duplication
        #
        # convenience accessors
        x_scale = @x_scale()
        y_scale = @y_scale()
        x_axis = @x_axis()
        y_axis = @y_axis()

        x_axis
            .scale x_scale
            .orient "bottom"
        
        y_axis 
            .scale y_scale
            .orient "left"

        d3.select element
            .selectAll ".y.axis"
            .data [data]
            .enter()
            .append "g"
            .classed "y axis", true
            .call y_axis

        d3.select element
            .selectAll ".x.axis"
            .data [data]
            .enter()
            .append "g"
            .classed "x axis", true
            .attr "transform", "translate(0, #{y_scale.range()[0]})"
            .call x_axis
