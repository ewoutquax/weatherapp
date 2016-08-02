require 'rails_helper'

RSpec.feature "Home", type: :feature do
  before do
    Measurement.create!(
      measured_at: "2016-08-01 18:53:48",
      temperature: "20.9",
      pressure:    101857,
      humidity:    "52.0"
    )
  end

  scenario 'Show the homepage' do
    visit '/'

    expect(page).to have_content('Laatste meting: 01 Aug 18:53')

    within '.navbar-header' do
      expect(page).to have_content('WeatherApp')
    end
  end
end
