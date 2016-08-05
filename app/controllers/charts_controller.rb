class ChartsController < ApplicationController
  def index
    redirect_to all_readings_charts_path
  end

  def all_readings
    @measurements = Measurement.order(:measured_at)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Alle metingen')
    render :show
  end

  def last_36_hours
    @measurements = Measurement.order(:measured_at).where('measured_at > :time', time: Time.now - 36.hours)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Afgelopen 36 uur')
    render :show
  end
end
