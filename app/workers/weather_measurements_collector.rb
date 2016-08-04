module Workers
  class WeatherMeasurementsCollector
    def self.invoke
      measurement = Measurement.new(measured_at: Time.now)
      Collector::WeatherMeasurements.new(measurement).invoke
      measurement.save!
      (builder = Builder::CurrentMeasurement.new).from_measurement(measurement)
      builder.current_measurement.save!
    end
  end
end
