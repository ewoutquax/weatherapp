require 'rails_helper'

RSpec.describe Builder::CurrentMeasurement do
  let(:builder) { Builder::CurrentMeasurement.new }

  context 'build_or_existing' do
    let(:current_measurement) { builder.build_or_existing; builder.current_measurement }

    before do
      data = {temperature: 27.1, pressure: 108000, humidity: 64.4}
      expect(Adafruit::SensorReader).to receive(:invoke).and_return(data)
    end

    context 'for new' do

      it 'builds a new measurement' do
        expect(current_measurement).to be_new_record
      end
      it 'populates the measurement correctly' do
        expect(current_measurement.is_current_reading).to eq(true)
        expect(current_measurement.measured_at).to_not be_nil
        expect(current_measurement.temperature).to eq(27.1)
        expect(current_measurement.pressure).to eq(108000)
        expect(current_measurement.humidity.to_f).to eq(64.4)
      end
    end

    context 'for existing' do
      it 'reuses the existing measurement' do
        Measurement.create(is_current_reading: true)

        expect(current_measurement).to be_persisted
      end
    end
  end
end
