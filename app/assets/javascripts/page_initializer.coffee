class @PageInitializer
  init: ->
    container = $('div#temperature')
    if container.length == 1
      (new window.TemperatureDrawer(container, window.temperatureMarks, window.noonMarks, window.temperatureScaleMarks)).drawChartOnResize()
    container = $('div#pressure')
    if container.length == 1
      (new window.PressureDrawer(container, window.pressureMarks, window.noonMarks, window.pressureScaleMarks)).drawChartOnResize()
