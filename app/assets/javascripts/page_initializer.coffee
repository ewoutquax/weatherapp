class @PageInitializer
  init: ->
    container = $('div#temperature')
    if container.length == 1
      (new window.TemperatureDrawer(container, window.temperatureMarks, window.noonMarks, window.temperatureScaleMarks)).drawChartOnResize()
