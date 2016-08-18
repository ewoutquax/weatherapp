class @PageInitializer
  init: ->
    container = $('div#temperature')
    if container.length == 1
      (new window.TemperatureDrawer(
        container
        window.temperatureMarks
        window.noonMarks
        window.temperatureScaleMarks
        window.sunRisesSets
      )).drawChartOnResize()

    container = $('div#pressure')
    if container.length == 1
      (new window.PressureDrawer(
        container
        window.pressureMarks
        window.noonMarks
        window.pressureScaleMarks
        window.sunRisesSets
      )).drawChartOnResize()

    container = $('div#humidity')
    if container.length == 1
      (new window.HumidityDrawer(
        container
        window.humidityMarks
        window.noonMarks
        window.humidityScaleMarks
        window.sunRisesSets
      )).drawChartOnResize()
