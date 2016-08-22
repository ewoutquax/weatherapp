class HomeController < ApplicationController
  def index
    last_measurements = Measurement.order(:measured_at).last(2)
    @current_measurement = last_measurements.pop
    @previous_measurement = last_measurements.pop
    sun_calculator = SunTimes.new

    current_date = Date.today
    time_rise = sun_calculator.rise(current_date, LOCATION_LATITUDE, LOCATION_LONGITUDE)
    time_set  = sun_calculator.set(current_date, LOCATION_LATITUDE, LOCATION_LONGITUDE)

    @suntimes = [Time.at(time_rise.to_i), Time.at(time_set.to_i)]
  end

  def update_current_reading
    (builder = Builder::CurrentMeasurement.new).build_or_existing
    builder.current_measurement.save!
    redirect_to root_path
  end
end
