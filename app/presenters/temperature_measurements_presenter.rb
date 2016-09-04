class TemperatureMeasurementsPresenter < MeasurementsPresenter
  def initialize(measurements, title = '')
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
  end

  def marks
    marks = []
    @measurements.each do |measurement|
      x = (measurement.measured_at.to_i - epoch_min) * 100.0 / width_range
      y = (measurement.temperature.to_f * 100.0 / max_height).round(2)
      marks << [x, y]
    end
    marks
  end

  def scales
    scale   = []
    current = 0
    while current < max_temperature
      height_percentage = (current * 100.0 / max_height).to_f.round(2)
      temperature = current.to_f.to_s.gsub('.',',')
      scale << [height_percentage, temperature]
      current += 5
    end

    height_percentage = (max_temperature * 100.0 / max_height).to_f.round(2)
    temperature = max_temperature.to_f.to_s.gsub('.',',')
    scale << [height_percentage, temperature]
  end

  private

    def max_height
      if(height = max_temperature * 1.1) < 10
        10
      else
        height
      end
    end

    def max_temperature
      @max_temperature ||= @measurements.map(&:temperature).reject(&:nil?).max
    end
end
