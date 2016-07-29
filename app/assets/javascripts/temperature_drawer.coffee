class @TemperatureDrawer
  HEIGHT = 200

  constructor: (@container, @measurements, @noons, @scales) ->
    @canvas    = @container.find('canvas')[0]
    @context   = @canvas.getContext("2d")

  drawChartOnResize: ->
    @drawChartAndNoons()
    window.addEventListener('resize', @drawChartAndNoons, false)

  drawChartAndNoons: =>
    @width = @container.width()

    @drawChart()
    @drawNoons()
    @drawScales()

  drawChart: ->
    @canvas.width   = @width
    @canvas.height  = HEIGHT

    @context.lineWidth   = 2
    @context.strokeStyle = '#666666'
    @context.fillStyle   = '#eeeeee'

    @context.beginPath()
    @context.moveTo(@width, HEIGHT)
    @context.lineTo(0, HEIGHT)
    $.each(@measurements, (idx, measurement) =>
      x = (@width / 100 * measurement.x)
      y = HEIGHT - (HEIGHT / 100 * measurement.y)
      @context.lineTo(x, y)
    )
    @context.closePath()

    @context.fill()
    @context.stroke()

  drawNoons: ->
    @context.lineWidth   = 1
    @context.strokeStyle = '#aaaaaa'

    $.each(@noons, (idx, noon) =>
      x = (@width / 100 * noon)
      @context.beginPath()
      @context.moveTo(x, 0)
      @context.lineTo(x, HEIGHT)
      @context.stroke()
    )

  drawScales: ->
    @context.lineWidth   = 1
    @context.strokeStyle = '#aaaaaa'

    $.each(@scales, (idx, scale) =>
      y = HEIGHT - (HEIGHT / 100 * scale)
      @context.beginPath()
      @context.moveTo(0, y)
      @context.lineTo(@width, y)
      @context.stroke()
    )
