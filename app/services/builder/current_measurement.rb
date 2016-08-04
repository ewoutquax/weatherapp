module Builder
  class CurrentMeasurement
    attr_reader :current_measurement

    def build_or_existing
      @current_measurement = measurement_to_use
      Collector::WeatherMeasurements.new(@current_measurement).invoke
    end

    private

      def measurement_to_use
        m = Measurement.where(is_current_reading: true).first_or_initialize
        m.assign_attributes(
          measured_at:        Time.now,
          is_current_reading: true
        )
        m
      end
  end
end
