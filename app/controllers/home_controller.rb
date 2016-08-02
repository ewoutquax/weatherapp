class HomeController < ApplicationController
  def index
    @presenter = MeasurementsPresenter.new(Measurement.order(:measured_at).to_a)
  end
end
