require 'rails_helper'

RSpec.feature "Home", type: :feature do
  scenario 'Show the homepage' do
    visit '/'

    within 'h1' do
      expect(page).to have_content('My WeatherApp')
    end
  end
end
