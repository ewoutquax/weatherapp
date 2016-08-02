require 'rails_helper'

RSpec.describe MeasurementsPresenter do
  context 'initialize' do
    it 'requires parameters' do
      expect{MeasurementsPresenter.new}.to raise_error(ArgumentError)
    end
    it 'raises an error, when the parameter is not an Array' do
      expect{MeasurementsPresenter.new('blabla')}.to raise_error(ArgumentError)
    end
    it 'requires an Array as parameter' do
      expect{MeasurementsPresenter.new([])}.to_not raise_error
    end
  end

  context 'temperatures' do
    context 'max height' do
      it 'sets the max-height at 110% of the maximum temperature in the list' do
        assert_max_height_for_temperatures([27.1, 15.9], 29.81)
      end

      it 'the max-height has a minimum of 10' do
        assert_max_height_for_temperatures([2.1, 8.9], 10.0)
      end

      def assert_max_height_for_temperatures(temperatures, expected_max_height)
        measurements = temperatures.inject([]) do |collection, temperature|
          collection << Measurement.new(temperature: temperature)
        end
        max_height = MeasurementsPresenter.new(measurements).send(:max_height_for_temperature)

        expect(max_height).to eq(expected_max_height)
      end
    end

    context 'scales' do
      it 'sets a scale for 0, and for the max-temperature' do
        assert_scales_for_temperatures([3.1], [[0.0, '0,0'], [31.0, '3,1']])
      end

      it 'add a scale for each multiple of 5' do
        assert_scales_for_temperatures([18.1], [[0.0, "0,0"], [25.11, "5,0"], [50.23, "10,0"], [75.34, "15,0"], [90.91, "18,1"]])
      end

      def assert_scales_for_temperatures(temperatures, expected_scales)
        measurements = temperatures.inject([]) do |collection, temperature|
          collection << Measurement.new(temperature: temperature)
        end

        expect(MeasurementsPresenter.new(measurements).temperature_scales).to eq(expected_scales)
      end
    end

    context 'temperature-marks' do
      it 'returns the x- and y-coordinates for the temperatures' do
        measurement_1 = Measurement.new(measured_at: Time.parse('7:00'), temperature: 2.3)
        measurement_2 = Measurement.new(measured_at: Time.parse('8:00'), temperature: 5.1)
        measurement_3 = Measurement.new(measured_at: Time.parse('9:00'), temperature: 8.9)

        presenter = MeasurementsPresenter.new([measurement_1, measurement_2, measurement_3])
        marks = presenter.temperature_marks

        expect(marks).to eq([[0.0, 23.0], [50.0, 51.0], [100.0, 89.0]])
      end
    end
  end

  context 'pressure' do
    let(:pressure_1) { Measurement.new(measured_at: Time.parse('7:00'), pressure: 108000) }
    let(:pressure_2) { Measurement.new(measured_at: Time.parse('8:00'), pressure: 111030) }
    let(:pressure_3) { Measurement.new(measured_at: Time.parse('9:00'), pressure: 110000) }

    context 'min height' do
      it 'sets the min-height at multiple of 100 below the lowest pressure' do
        min_height = MeasurementsPresenter.new([pressure_1, pressure_2]).send(:min_height_for_pressure)
        expect(min_height).to eq(108000)
      end
    end

    context 'max height' do
      it 'sets the max-height at 110% of the pressure-range adding the height-offset' do
        max_height = MeasurementsPresenter.new([pressure_1, pressure_2]).send(:max_height_for_pressure)
        expect(max_height).to eq(111333)
      end
    end

    context 'scales' do
      it 'sets a scale for 0, the min-height and the max-pressure' do
        scales = MeasurementsPresenter.new([pressure_1]).pressure_scales

        expect(scales).to eq([[0, 0], [5.0, 100000], [91.36, 108000]])
      end

      it 'add a scale for each multiple of 10000' do
        scales = MeasurementsPresenter.new([pressure_1, pressure_2]).pressure_scales

        expect(scales).to eq([[0, 0], [5.0, 100000], [62.58, 110000], [91.36, 115000]])
      end
    end

    context 'pressure-marks' do
      it 'returns the x- and y-coordinates for the temperatures' do
        presenter = MeasurementsPresenter.new([pressure_1, pressure_2, pressure_3])
        marks = presenter.pressure_marks

        expect(marks).to eq([[0.0, 5.0], [50.0, 91.36], [100.0, 62.01]])
      end
    end
  end

  context 'humidity' do
    let(:humidity_1) { Measurement.new(measured_at: Time.parse('7:00'), humidity: 52.0) }
    let(:humidity_2) { Measurement.new(measured_at: Time.parse('8:00'), humidity: 56.1) }
    let(:humidity_3) { Measurement.new(measured_at: Time.parse('9:00'), humidity: 66.2) }

    context 'min height' do
      it 'sets the min-height at multiple of 5 below the lowest pressure' do
        min_height = MeasurementsPresenter.new([humidity_1, humidity_2]).send(:min_height_for_humidity)
        expect(min_height).to eq(50.0)
      end
    end

    context 'max height' do
      it 'sets the max-height at 110% of the humidity-range adding the height-offset' do
        max_height = MeasurementsPresenter.new([humidity_1, humidity_2]).send(:max_height_for_humidity)
        expect(max_height).to eq(56.7)
      end
    end

    context 'scales' do
      it 'sets a scale for 0, the min-height and the max-humidity' do
        scales = MeasurementsPresenter.new([humidity_1]).humidity_scales

        expect(scales).to eq([[0, 0], [5.0, 50.0], [91.36, 52.0]])
      end

      it 'add a scale for each multiple of 5' do
        scales = MeasurementsPresenter.new([humidity_1, humidity_2]).humidity_scales

        expect(scales).to eq([[0, 0], [5.0, 50.0], [75.9, 55.0], [91.49, 56.1]])
      end
    end

    context 'humidity-marks' do
      it 'returns the x- and y-coordinates for the humidities' do
        presenter = MeasurementsPresenter.new([humidity_1, humidity_2, humidity_3])
        marks = presenter.humidity_marks

        expect(marks).to eq([[0.0, 15.67], [50.0, 37.56], [100.0, 91.46]])
      end
    end
  end

  context 'noon-marks' do
    before do
      Timecop.travel(Date.parse('2016-07-29'))
    end
    after do
      Timecop.return
    end

    it 'are not set, when the measumerement-times do not pass a noon' do
      measured_ats = [
        Time.parse('10:00'),
        Time.parse('11:00')
      ]

      assert_noons_for_measurements(measured_ats, [])
    end

    it 'returns the value of 50, when the noon is in the middle' do
      measured_ats = [
        Time.parse('11:00'),
        Time.parse('13:00')
      ]

      assert_noons_for_measurements(measured_ats, [[50.0, '29-07-2016']])
    end

    it 'returns the value of 10, 50 and 90, when multiple noons are present' do
      measured_ats = [
        Time.parse('6:00')  - 1.day,
        Time.parse('18:00') + 1.day
      ]

      assert_noons_for_measurements(measured_ats, [[10.0, "28-07-2016"], [50.0, "29-07-2016"], [90.0, "30-07-2016"]])
    end

    def assert_noons_for_measurements(measured_ats, expected_result)
      measurements = measured_ats.inject([]) do |collection, measured_at|
        collection << Measurement.new(measured_at: measured_at)
      end

      expect(MeasurementsPresenter.new(measurements).noon_marks).to eq(expected_result)
    end
  end

  context 'next-noon-after-epoch' do
    before do
      Timecop.travel(Date.parse('2016-07-28'))
    end
    after do
      Timecop.return
    end

    it 'is on the same day, if the reference-epoch is in the morning' do
      assert_next_noon_epoch(Time.parse('9:00').to_i, 1469700000) # 2016-07-28 12:00:00 +0200
    end
    it 'is on the next day, if the reference-epoch is in the afternoon' do
      assert_next_noon_epoch(Time.parse('15:00').to_i, 1469786400) # 2016-07-29 12:00:00 +0200
    end

    def assert_next_noon_epoch(reference_epoch, expected_noon_epoch)
      noon = MeasurementsPresenter.next_noon_after_epoch(reference_epoch)
      expect(noon).to eq(expected_noon_epoch)
    end
  end
end
