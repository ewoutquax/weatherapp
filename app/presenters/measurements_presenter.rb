class MeasurementsPresenter
  attr_reader :title

  def initialize(measurements, title = '')
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
    @title        = title
  end

  def temperature_marks
    TemperatureMeasurementsPresenter.new(@measurements).marks
  end

  def pressure_marks
    PressureMeasurementsPresenter.new(@measurements).marks
  end

  def humidity_marks
    HumidityMeasurementsPresenter.new(@measurements).marks
  end

  def temperature_scales
    TemperatureMeasurementsPresenter.new(@measurements).scales
  end

  def pressure_scales
    PressureMeasurementsPresenter.new(@measurements).scales
  end

  def humidity_scales
    HumidityMeasurementsPresenter.new(@measurements).scales
  end

  def noon_marks
    noon_epoch = self.class.next_noon_after_epoch(epoch_min)

    marks = []
    while noon_epoch < epoch_max
      x = (noon_epoch - epoch_min) * 100.0 / width_range
      date = Time.at(noon_epoch).strftime('%d-%m-%Y')
      marks << [x, date]
      noon_epoch += 86400
    end

    marks
  end

  def sun_rises_sets
    sun_calculator = SunTimes.new

    suntimes = []
    current_date = @measurements.first.measured_at.to_date
    end_date = @measurements.last.measured_at.to_date
    while current_date < end_date
      time_set  = sun_calculator.set(current_date, 52.668393, 4.830894)
      time_rise = sun_calculator.rise(current_date + 1.day, 52.668393, 4.830894)

      x_set  = ((time_set.to_i  - epoch_min) * 100.0 / width_range).round(2)
      x_rise = ((time_rise.to_i - epoch_min) * 100.0 / width_range).round(2)
      x_set  = 0   if x_set  < 0
      x_rise = 100 if x_rise > 100
      suntimes << [x_set, x_rise]

      current_date += 1.day
    end
    suntimes
  end

  private

    def width_range
      epoch_max - epoch_min
    end

    def epoch_max
      @measurements.last.measured_at.to_i
    end

    def epoch_min
      @measurements.first.measured_at.to_i
    end

    def self.next_noon_after_epoch(reference_epoch)
      noon = Time.at(reference_epoch).noon.to_i
      if noon < reference_epoch
        noon = (Time.at(reference_epoch) + 1.day).noon.to_i
      end
      noon
    end
end
