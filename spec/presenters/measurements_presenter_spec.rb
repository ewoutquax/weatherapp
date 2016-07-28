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

  end

  context 'noon-marks' do
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

      assert_noons_for_measurements(measured_ats, [50.0])
    end

    it 'returns the value of 10, 50 and 90, when multiple noons are present' do
      measured_ats = [
        Time.parse('6:00') - 1.day,
        Time.parse('18:00') + 1.day
      ]

      assert_noons_for_measurements(measured_ats, [10.0, 50.0, 90.0])
    end

    def assert_noons_for_measurements(measured_ats, expected_result)
      measurements = measured_ats.inject([]) do |collection, measured_at|
        collection << Measurement.new(measured_at: measured_at)
      end

      presenter = MeasurementsPresenter.new(measurements)

      expect(presenter.noon_marks).to eq(expected_result)
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
