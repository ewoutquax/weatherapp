Rails.application.routes.draw do
  root to: 'home#index'

  post 'update_current_reading' => 'home#update_current_reading'
  get 'chart'              => 'home#chart'
  get 'chart_all_readings' => 'home#chart_all_readings'
  get 'chart_36_hours'     => 'home#chart_36_hours'
end
