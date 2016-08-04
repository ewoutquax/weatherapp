class HomeController < ApplicationController
  def index
    @current_measurement = Measurement.find_by(is_current_reading: true)
    @measurements = Measurement.order(:measured_at)
    @presenter = MeasurementsPresenter.new(@measurements.to_a)
  end
end
