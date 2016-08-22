class MeasurementsPresenter
  attr_reader :title

  def initialize(measurements, title = '')
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
    @title        = title
  end

  def temperature_marks
    marks = []
    @measurements.each do |measurement|
      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = (measurement.temperature.to_f * 100.0 / max_height_for_temperature).round(2)
      marks << [x, y]
    end
    marks
  end

  def pressure_marks
    marks = []
    @measurements.each do |measurement|
      next if measurement.pressure.blank?

      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = ((measurement.pressure - min_height_for_pressure) * 95.0 / height_range_for_pressure).round(2) + 5.0
      marks << [x, y]
    end
    marks
  end

  def humidity_marks
    marks = []
    @measurements.each do |measurement|
      next if measurement.humidity.blank? || measurement.humidity > 100

      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = ((measurement.humidity.to_f - min_height_for_humidity) * 95.0 / height_range_for_humidity).round(2) + 5.0
      marks << [x, y]
    end
    marks
  end

  def temperature_scales
    max = max_temperature

    scale   = []
    current = 0
    while current < max
      height_percentage = (current * 100.0 / max_height_for_temperature).to_f.round(2)
      temperature = current.to_f.to_s.gsub('.',',')
      scale << [height_percentage, temperature]
      current += 5
    end

    height_percentage = (max * 100.0 / max_height_for_temperature).to_f.round(2)
    temperature = max.to_f.to_s.gsub('.',',')
    scale << [height_percentage, temperature]
  end

  def pressure_scales
    scale = [[0, 0]]

    current = min_height_for_pressure
    while current < max_pressure
      height = ((current - min_height_for_pressure) * 95.0 / height_range_for_pressure).round(2) + 5.0
      scale << [height, current / 100]
      current += 100
    end

    height = ((max_pressure - min_height_for_pressure) * 95.0 / height_range_for_pressure).round(2) + 5.0
    scale << [height, max_pressure.to_f / 100]
  end

  def humidity_scales
    scale = [[0, 0]]

    current = min_height_for_humidity
    while current < max_humidity
      height = ((current - min_height_for_humidity) * 95.0 / height_range_for_humidity).to_f.round(2) + 5.0
      scale << [height, current]
      current += 5
    end

    height = ((max_humidity - min_height_for_humidity) * 95.0 / height_range_for_humidity).to_f.round(2) + 5.0
    scale << [height, max_humidity]
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

    def max_height_for_temperature
      if(max_height = max_temperature * 1.1) < 10
        10
      else
        max_height
      end
    end

    def height_range_for_pressure
      max_height_for_pressure - min_height_for_pressure
    end

    def max_height_for_pressure
      ((max_pressure - min_height_for_pressure) * 1.1 + min_height_for_pressure).round
    end

    def min_height_for_pressure
      (min_pressure / 100).floor * 100
    end

    def max_temperature
      @measurements.map(&:temperature).reject(&:nil?).max
    end

    def max_pressure
      @measurements.map(&:pressure).reject(&:nil?).max
    end

    def min_pressure
      @measurements.map(&:pressure).reject(&:nil?).min
    end

    def height_range_for_humidity
      max_height_for_humidity - min_height_for_humidity
    end

    def max_height_for_humidity
      ((max_humidity - min_height_for_humidity) * 1.1 + min_height_for_humidity).round(1)
    end

    def min_height_for_humidity
      (min_humidity / 5).floor.to_f * 5
    end

    def max_humidity
      @measurements.map(&:humidity).reject(&:nil?).max.to_f
    end

    def min_humidity
      @measurements.map(&:humidity).reject(&:nil?).min.to_f
    end

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
