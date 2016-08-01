module Adafruit
  module SensorReader
    def self.invoke
      reading_temperature_pressure = `/srv/python/Adafruit_Python_BMP/api.py`.split("\n")
      reading_temperature_humidity = `/srv/python/Adafruit_Python_DHT/examples/api.py`.split("\n")

      {
        temperature: reading_temperature_pressure[0],
        pressure:    reading_temperature_pressure[1],
        humidity:    reading_temperature_humidity[1]
      }
    end
  end
end
