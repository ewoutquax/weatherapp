class MeasurementsPresenter
  def initialize(measurements)
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
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

  private

    def max_height_for_temperature
      if(max_height = max_temperature * 1.1) < 10
        10
      else
        max_height
      end
    end

    def max_height_for_pressure
      (max_pressure * 1.1).round
    end

    def min_height_for_pressure
      (min_pressure / 10000).floor * 10000
    end

    def max_temperature
      max = 0
      @measurements.each do |measurement|
        if max < measurement.temperature
          max = measurement.temperature
        end
      end
      max
    end

    def max_pressure
      max = 0
      @measurements.each do |measurement|
        if max < measurement.pressure
          max = measurement.pressure
        end
      end
      max
    end

    def min_pressure
      min = @measurements.first.pressure
      @measurements.each do |measurement|
        if min > measurement.pressure
          min = measurement.pressure
        end
      end
      min
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
