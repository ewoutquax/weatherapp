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
      measumerement_1 = Measurement.new(measured_at: Time.parse('10:00'))
      measumerement_2 = Measurement.new(measured_at: Time.parse('11:00'))

      presenter = MeasurementsPresenter.new([measumerement_1, measumerement_2])

      expect(presenter.noon_marks).to eq([])
    end

    it 'returns the value of 50, when the noon is in the middle' do
      measumerement_1 = Measurement.new(measured_at: Time.parse('11:00'))
      measumerement_2 = Measurement.new(measured_at: Time.parse('13:00'))

      presenter = MeasurementsPresenter.new([measumerement_1, measumerement_2])

      expect(presenter.noon_marks).to eq([50.0])
    end

    it 'returns the value of 10, 50 and 90, when multiple noons are present' do
      measumerement_1 = Measurement.new(measured_at: Time.parse('6:00') - 1.day)
      measumerement_2 = Measurement.new(measured_at: Time.parse('18:00') + 1.day)

      presenter = MeasurementsPresenter.new([measumerement_1, measumerement_2])

      expect(presenter.noon_marks).to eq([10.0, 50.0, 90.0])
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
      reference_epoch = Time.parse('9:00').to_i
      noon = MeasurementsPresenter.next_noon_after_epoch(reference_epoch)
      expect(noon).to eq(1469700000) # 2016-07-28 12:00:00 +0200
    end
    it 'is on the next day, if the reference-epoch is in the afternoon' do
      reference_epoch = Time.parse('15:00').to_i
      noon = MeasurementsPresenter.next_noon_after_epoch(reference_epoch)
      expect(noon).to eq(1469786400) # 2016-07-29 12:00:00 +0200
    end
  end
end
