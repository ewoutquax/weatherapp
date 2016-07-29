class @PageInitializer
  init: ->
    container = $('canvas#temperature').closest('div')
    if container.length == 1
      (new window.TemperatureDrawer(container, window.temperatureMarks, window.noonMarks, window.temperatureScaleMarks)).drawChartOnResize()
