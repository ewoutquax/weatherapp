class HomeController < ApplicationController
  def index
    last_measurements = Measurement.order(:measured_at).last(2)
    @current_measurement = last_measurements.pop
    @previous_measurement = last_measurements.pop
  end

  def chart
    @measurements = Measurement.order(:measured_at)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a)
  end

  def update_current_reading
    (builder = Builder::CurrentMeasurement.new).build_or_existing
    builder.current_measurement.save!
    redirect_to root_path
  end
end
