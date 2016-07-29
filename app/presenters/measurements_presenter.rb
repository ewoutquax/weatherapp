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
      scale << (current * 100.0 / max_height_for_temperature).to_f.round(2)
      current += 5
    end

    scale << (max * 100.0 / max_height_for_temperature).to_f.round(2)
  end

  def noon_marks
    noon_epoch = self.class.next_noon_after_epoch(epoch_min)

    marks = []
    while noon_epoch < epoch_max
      marks << (noon_epoch - epoch_min) * 100.0 / width_range
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

    def max_temperature
      max = 0
      @measurements.each do |measurement|
        if max < measurement.temperature
          max = measurement.temperature
        end
      end
      max
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
