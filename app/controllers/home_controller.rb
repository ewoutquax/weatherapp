class HomeController < ApplicationController
  def index
    @current_measurement = Measurement.order(:measured_at).last
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
