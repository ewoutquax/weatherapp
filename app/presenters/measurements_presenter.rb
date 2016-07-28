class MeasurementsPresenter
  def initialize(measurements)
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
  end

  def noon_marks
    epoch_min = @measurements.first.measured_at.to_i
    epoch_max = @measurements.last.measured_at.to_i
    range = epoch_max - epoch_min

    noon = self.class.next_noon_after_epoch(epoch_min)

    marks = []
    while noon < epoch_max
      marks << (noon - epoch_min) * 100.0 / range
      noon += 86400
    end

    marks
  end

  def self.next_noon_after_epoch(reference_epoch)
    # First noon after the epoch_min
    noon = Time.at(reference_epoch).noon.to_i
    if noon < reference_epoch
      noon = (Time.at(reference_epoch) + 1.day).noon.to_i
    end
    noon
  end
end
