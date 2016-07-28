class HomeController < ApplicationController
  def index
    @presenter = MeasurementsPresenter.new(Measurement.all.to_a)
  end
end
