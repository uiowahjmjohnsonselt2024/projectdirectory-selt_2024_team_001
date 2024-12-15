require 'rails_helper'

RSpec.describe 'Profile Picture Update', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = User.create!(
      email: 'test@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!'
    )
    login_as(@user, scope: :user)
  end

  it 'updates the profile picture successfully when an image is selected' do
    visit user_profile_path

    find('#current-profile-picture').click
    expect(page).to have_css('#dropdown-menu', visible: true)

    find('#dropdown-menu .profile-option img', match: :first).click
    find('.dropdown-save-btn .btn').click

    expect(page).to have_content('Profile picture updated successfully in session!')
  end

  it 'shows an alert when saving without selecting an image' do
    visit user_profile_path

    find('#current-profile-picture').click
    expect(page).to have_css('#dropdown-menu', visible: true)

    find('.dropdown-save-btn .btn').click

    expect(page).to have_content('No image selected!')
  end

  it 'does not change the profile picture if no image is selected' do
    visit user_profile_path

    original_src = find('#current-profile-picture')[:src]
    find('#current-profile-picture').click

    find('.dropdown-save-btn .btn').click
    expect(find('#current-profile-picture')[:src]).to eq(original_src)
  end
end
