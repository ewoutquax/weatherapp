class PressureMeasurementsPresenter < MeasurementsPresenter
  def initialize(measurements)
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
  end

  def marks
    marks = []
    @measurements.each do |measurement|
      next if measurement.pressure.blank?

      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = ((measurement.pressure - min_height) * 95.0 / height_range).round(2) + 5.0
      marks << [x, y]
    end
    marks
  end

  def scales
    scale = [[0, 0]]

    current = min_height
    while current < max_pressure
      height = ((current - min_height) * 95.0 / height_range).round(2) + 5.0
      scale << [height, current / 100]
      current += 100
    end

    height = ((max_pressure - min_height) * 95.0 / height_range).round(2) + 5.0
    scale << [height, max_pressure.to_f / 100]
  end

  private

    def height_range
      max_height - min_height
    end

    def max_height
      ((max_pressure - min_height) * 1.1 + min_height).round
    end

    def min_height
      (min_pressure / 100).floor * 100
    end

    def max_pressure
      @max_pressure ||= @measurements.map(&:pressure).reject(&:nil?).max
    end

    def min_pressure
      @min_pressure ||= @measurements.map(&:pressure).reject(&:nil?).min
    end
end
