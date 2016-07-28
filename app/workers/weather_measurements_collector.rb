module Workers
  class WeatherMeasurementsCollector
    def self.invoke
      measurement = Measurement.new(measured_at: Time.now)
      Collector::WeatherMeasurements.new(measurement).invoke
      measurement.save!
    end
  end
end
