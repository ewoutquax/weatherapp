class MeasurementsPresenter
  def initialize(measurements)
    raise ArgumentError, measurements.class.to_s unless measurements.is_a?(Array)

    @measurements = measurements
  end

  def noon_marks
    noon_epoch = self.class.next_noon_after_epoch(epoch_min)

    marks = []
    while noon_epoch < epoch_max
      marks << (noon_epoch - epoch_min) * 100.0 / range
      noon_epoch += 86400
    end

    marks
  end

  def range(epoch_max, epoch_min)
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
