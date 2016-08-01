module Collector
  class WeatherMeasurements
    def initialize(measurement)
      raise ArgumentError, measurement.class.to_s unless measurement.is_a?(Measurement)
      @measurement = measurement
    end

    def invoke
      data = Adafruit::SensorReader.invoke

      @measurement.assign_attributes(
        temperature: data[:temperature],
        pressure:    data[:pressure],
        humidity:    data[:humidity]
      )
    end
  end
end
