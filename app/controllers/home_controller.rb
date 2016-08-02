class HomeController < ApplicationController
  def index
    @measurements = Measurement.order(:measured_at)
    @presenter = MeasurementsPresenter.new(@measurements.to_a)
  end
end
