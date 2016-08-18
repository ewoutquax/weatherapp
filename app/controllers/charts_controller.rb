class ChartsController < ApplicationController
  def index
    redirect_to last_48_hours_charts_path
  end

  def last_48_hours
    @measurements = Measurement.order(:measured_at).where('measured_at > :time', time: Time.now - 48.hours)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Afgelopen 48 uur')
    render :show
  end

  def all_readings
    @measurements = Measurement.order(:measured_at)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Alle metingen')
    render :show
  end
end
