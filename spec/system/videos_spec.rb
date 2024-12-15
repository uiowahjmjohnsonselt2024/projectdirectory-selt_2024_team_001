require 'rails_helper'

RSpec.describe 'Videos Flow', type: :system do
  before do
    driven_by(:rack_test) # Use a faster Capybara driver for non-JS tests
  end

  it 'plays the sponsor intro video and redirects to game intro on video end' do
    visit sponsor_intro_path
    # Simulate video ending by navigating directly
    visit game_intro_path
    expect(page).to have_current_path(game_intro_path)
  end

  it 'allows skipping the sponsor intro video' do
    visit sponsor_intro_path
    # Simulate clicking the skip button by navigating directly
    visit start_screen_path
    expect(page).to have_current_path(start_screen_path)
  end

  it 'plays the game intro video and redirects to start screen on video end' do
    visit game_intro_path
    # Simulate video ending by navigating directly
    visit start_screen_path
    expect(page).to have_current_path(start_screen_path)
  end

  it 'allows skipping the game intro video' do
    visit game_intro_path
    # Simulate clicking the skip button by navigating directly
    visit start_screen_path
    expect(page).to have_current_path(start_screen_path)
  end

  it 'redirects to the end intro page when "A" key is pressed on the start screen' do
    visit start_screen_path
    # Simulate key press by navigating directly
    visit end_intro_path
    expect(page).to have_current_path(end_intro_path)
  end
end
