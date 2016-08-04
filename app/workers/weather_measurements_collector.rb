module Workers
  class WeatherMeasurementsCollector
    def self.invoke
      measurement = Measurement.new(measured_at: Time.now)
      Collector::WeatherMeasurements.new(measurement).invoke
      measurement.save!
      Measurement.where(is_current_reading: true).delete_all
    end
  end
end
