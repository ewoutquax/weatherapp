module Collector
  class WeatherMeasurements
    def initialize(measurement)
      raise ArgumentError, measurement.class.to_s unless measurement.is_a?(Measurement)
      @measurement = measurement
    end

    def invoke
      @measurement.assign_attributes(
        temperature: 27.1,
        pressure:    108000,
        humidity:    64
      )
    end
  end
end
