require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #start_screen' do
    it 'renders the start_screen template' do
      get :start_screen
      expect(response).to render_template('menus/start_screen')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #sponsor_intro' do
    it 'renders the sponsor_intro template' do
      get :sponsor_intro
      expect(response).to render_template('menus/sponsor_intro')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #game_intro' do
    it 'renders the game_intro template' do
      get :game_intro
      expect(response).to render_template('menus/game_intro')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #end_intro' do
    it 'renders the login_menu template' do
      get :end_intro
      expect(response).to render_template('menus/login_menu')
      expect(response).to have_http_status(:ok)
    end
  end
end
