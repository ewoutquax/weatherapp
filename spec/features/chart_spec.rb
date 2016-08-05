require 'rails_helper'

RSpec.feature "Chart", type: :feature do
  before do
    Timecop.travel(Time.parse('2016-08-01 19:00'))
  end

  after do
    Timecop.return
  end

  scenario 'full chart' do
    given_i_have_2_measurements
    when_i_am_on_the_homepage
    and_i_click_the_charts_link
    then_i_see_the_details_of_the_last_measurement
    and_i_see_the_header_for_full_overview
    and_i_see_the_all_measurements_link_as_active
    and_i_see_3_charts
  end

  scenario 'last 36 hours' do
    given_i_have_2_measurements
    when_i_am_on_the_homepage
    and_i_click_the_charts_link
    and_i_click_36_hours_link
    then_i_see_the_details_of_the_last_measurement
    and_i_see_the_header_for_36_hours
    and_i_see_the_36_hour_link_as_active
    and_i_see_3_charts
  end

  def given_i_have_2_measurements
    Measurement.delete_all
    Measurement.create!(
      measured_at: Time.parse('13:27:15') - 5.days,
      temperature: "20.9",
      pressure:    101857,
      humidity:    "52.0",
      is_current_reading: false
    )
    Measurement.create!(
      measured_at: Time.parse('18:53:48'),
      temperature: "18.3",
      pressure:    100125,
      humidity:    "78.2",
      is_current_reading: true
    )
  end

  def when_i_am_on_the_homepage
    visit '/'
  end

  def and_i_click_the_charts_link
    within('#navbar') do
      click_link('Chart')
    end
  end

  def and_i_click_36_hours_link
    click_link('Afgelopen 36 uur')
  end

  def then_i_see_the_details_of_the_last_measurement
    expect(page).to have_content('Recenste meting: 01 Aug 18:53')
  end

  def and_i_see_the_header_for_full_overview
    within('.panel-group h3') do
      expect(page).to have_content('Alle metingen')
    end
  end

  def and_i_see_the_all_measurements_link_as_active
    within('.nav-pills li.active') do
      expect(page).to have_content('Alle metingen')
    end
  end

  def and_i_see_the_36_hour_link_as_active
    within('.nav-pills li.active') do
      expect(page).to have_content('Afgelopen 36 uur')
    end
  end

  def and_i_see_the_header_for_36_hours
    within('.panel-group h3') do
      expect(page).to have_content('Afgelopen 36 uur')
    end
  end

  def and_i_see_3_charts
    expect(page).to have_selector('#temperature')
    expect(page).to have_selector('#pressure')
    expect(page).to have_selector('#humidity')
  end
end
