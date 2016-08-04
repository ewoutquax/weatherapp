module Builder
  class CurrentMeasurement
    attr_reader :current_measurement

    def build_or_existing
      @current_measurement = measurement_to_use
      Collector::WeatherMeasurements.new(@current_measurement).invoke
    end

    def from_measurement(measurement)
      raise ArgumentError, measurement.class.to_s unless measurement.is_a?(::Measurement)

      @current_measurement = measurement_to_use
      @current_measurement.assign_attributes(
        temperature:        measurement.temperature,
        pressure:           measurement.pressure,
        humidity:           measurement.humidity
      )
    end

    private

      def measurement_to_use
        Measurement.where(is_current_reading: true).first_or_initialize(
          measured_at:        Time.now,
          is_current_reading: true
        )
      end
  end
end
