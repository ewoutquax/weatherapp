Rails.application.routes.draw do
  root to: 'home#index'

  post 'update_current_reading' => 'home#update_current_reading'

  resources :charts, only: :index do
    collection do
      get :all_readings
      get :last_48_hours
    end
  end
end
