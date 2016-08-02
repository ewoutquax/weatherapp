job_type :runner, "cd :path && RAILS_ENV=:environment bundle exec bin/rails runner ':task' :output"

every 30.minutes do
  runner 'Workers::WeatherMeasurementsCollector.invoke'
end
