Rails.application.routes.draw do
  root to: 'home#index'

  post 'update_current_reading' => 'home#update_current_reading'
  get 'chart' => 'home#chart'
end
