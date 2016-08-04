require 'rails_helper'

RSpec.describe Workers::WeatherMeasurementsCollector do
  context 'overhead' do
    let(:mock_collector) { double('Collector::WeatherMeasurements', invoke: nil) }

    before do
      expect(Collector::WeatherMeasurements).to receive(:new).with(Measurement).and_return(mock_collector)
      expect(mock_collector).to receive(:invoke)
    end

    it 'runs without error' do
      expect{Workers::WeatherMeasurementsCollector.invoke}.to_not raise_error
    end
  end

  context 'invoke' do
    before do
      Measurement.create!(is_current_reading: true)

      data = {temperature: 27.1, pressure: 108000, humidity: 64.4}
      expect(Adafruit::SensorReader).to receive(:invoke).and_return(data)
      Workers::WeatherMeasurementsCollector.invoke
    end

    it 'deletes the last current-reading' do
      expect(Measurement.where(is_current_reading: true).count).to eq(0)
    end

    it 'writes a record to the measurements-table' do
      expect(Measurement.count).to eq(1)
    end

    it 'populates the record correctly' do
      measurement = Measurement.last
      expect(measurement.temperature).to eq(27.1)
      expect(measurement.pressure).to eq(108000)
      expect(measurement.humidity.to_f).to eq(64.4)
    end
  end
end
