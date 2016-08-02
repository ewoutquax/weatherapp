class @HumidityDrawer
  HEIGHT = 200

  constructor: (@container, @measurements, @noons, @scales) ->
    @canvas    = @container.find('canvas')[0]
    @context   = @canvas.getContext("2d")

  drawChartOnResize: ->
    @drawChartAndNoons()
    window.addEventListener('resize', @drawChartAndNoons, false)

  drawChartAndNoons: =>
    @width = @container.width() - 35
    @canvas.width   = @width
    @canvas.height  = HEIGHT

    @removeLegends()
    @drawChart()
    @drawNoons()
    @drawScales()

  removeLegends: ->
    @container.find('span').remove()

  drawChart: ->
    @context.lineWidth   = 2
    @context.strokeStyle = '#D372D3'
    @context.fillStyle   = '#FFE0FF'

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
      x = (@width / 100 * noon[0])
      @context.beginPath()
      @context.moveTo(x, 0)
      @context.lineTo(x, HEIGHT)
      @context.stroke()

      span = $('<span>')
      span.append(noon[1])
      span.css('right', "#{@width - @width * noon[0] / 100}px")
      span.css('bottom', '-25px')
      span.css('transform', 'rotate(315deg)')
      @container.append(span)
    )

  drawScales: ->
    @context.lineWidth   = 1
    @context.strokeStyle = '#aaaaaa'

    $.each(@scales, (idx, scale) =>
      y = HEIGHT - (HEIGHT / 100 * scale[0])
      @context.beginPath()
      @context.moveTo(0, y)
      @context.lineTo(@width, y)
      @context.stroke()

      span = $('<span>')
      span.append(scale[1])
      span.css('left', '0')
      span.css('bottom', "#{scale[0]}%")
      @container.append(span)
    )
