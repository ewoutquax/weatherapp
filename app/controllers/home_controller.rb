class HomeController < ApplicationController
  def index
    last_measurements = Measurement.order(:measured_at).last(2)
    @current_measurement = last_measurements.pop
    @previous_measurement = last_measurements.pop
  end

  def chart
    redirect_to chart_all_readings_path
  end

  def chart_all_readings
    @measurements = Measurement.order(:measured_at)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Alle metingen')
    render :chart
  end

  def chart_36_hours
    @measurements = Measurement.order(:measured_at).where('measured_at > :time', time: Time.now - 36.hours)
    @presenter    = MeasurementsPresenter.new(@measurements.to_a, 'Afgelopen 36 uur')
    render :chart
  end

  def update_current_reading
    (builder = Builder::CurrentMeasurement.new).build_or_existing
    builder.current_measurement.save!
    redirect_to root_path
  end
end
