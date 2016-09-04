class HumidityMeasurementsPresenter < MeasurementsPresenter
  def initialize(measurements, title = '')
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
  end

  def marks
    marks = []
    @measurements.each do |measurement|
      next if measurement.humidity.blank? || measurement.humidity > 100

      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = ((measurement.humidity.to_f - min_height) * 95.0 / height_range).round(2) + 5.0
      marks << [x, y]
    end
    marks
  end

  def scales
    scale = [[0, 0]]

    current = min_height
    while current < max_humidity
      height = ((current - min_height) * 95.0 / height_range).to_f.round(2) + 5.0
      scale << [height, current]
      current += 5
    end

    height = ((max_humidity - min_height) * 95.0 / height_range).to_f.round(2) + 5.0
    scale << [height, max_humidity]
  end

  private

    def height_range
      max_height - min_height
    end

    def max_height
      ((max_humidity - min_height) * 1.1 + min_height).round(1)
    end

    def min_height
      (min_humidity / 5).floor.to_f * 5
    end

    def max_humidity
      @measurements.map(&:humidity).reject(&:nil?).max.to_f
    end

    def min_humidity
      @measurements.map(&:humidity).reject(&:nil?).min.to_f
    end
end
