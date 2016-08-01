job_type :runner,  "cd :path && RAILS_ENV=:environment bundle exec script/rails runner ':task' :output"

every 30.minutes do
  runner 'Workers::WeatherMeasurementsCollector.invoke'
end
