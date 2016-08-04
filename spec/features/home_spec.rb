require 'rails_helper'

RSpec.feature "Home", type: :feature do
  before do
    Measurement.create!(
      measured_at: "2016-08-01 18:53:48",
      temperature: "20.9",
      pressure:    101857,
      humidity:    "52.0",
      is_current_reading: false
    )
  end

  scenario 'Show the homepage without current reading' do
    given_i_have_no_current_reading
    when_i_am_on_the_homepage
    then_i_see_a_message_about_no_current_reading
  end

  scenario 'Show the homepage with current reading' do
    given_i_have_a_current_reading
    when_i_am_on_the_homepage
    then_i_see_the_details_of_the_current_reading
  end

  scenario 'Show the charts' do
    given_i_have_non_current_measurements
    when_i_am_on_the_homepage
    and_i_click_the_charts_link
    then_is_see_the_details_of_the_last_measurement
    and_i_see_3_charts
  end

  def given_i_have_no_current_reading
    Measurement.last.update(is_current_reading: false)
  end

  def given_i_have_a_current_reading
    Measurement.last.update(is_current_reading: true)
  end

  def given_i_have_non_current_measurements
    Measurement.update_all(is_current_reading: false)
  end

  def when_i_am_on_the_homepage
    visit '/'
  end

  def then_i_see_a_message_about_no_current_reading
    expect(page).to have_content('Geen huidige meting aanwezig')
  end

  def then_i_see_the_details_of_the_current_reading
    expect(page).to have_content('Huidige meting')
    expect(page).to have_content('Meting gedaan op:01 Aug 18:53')
    expect(page).to have_content('Temperatuur:20,9 °C')
    expect(page).to have_content('Luchtdruk:1018,57 hP')
    expect(page).to have_content('Vochtigheidsgraad:52,0 %')
  end

  def then_i_see_the_details_of_the_last_measurement(page)
    expect(page).to have_content('Laatste meting: 01 Aug 18:53')
  end
end
