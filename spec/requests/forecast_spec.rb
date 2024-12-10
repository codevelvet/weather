require 'rails_helper'

RSpec.describe "Forecast", type: :request do
  RSpec.shared_examples "a forecast search prompt" do
    it 'renders the show template' do
      make_request
      expect(response).to render_template(:show)
    end

    it 'renders the search input' do
      make_request
      assert_select("[data-testid='forecast-search-input']")
    end
  end

  describe "GET /" do
    subject(:make_request) { get '/' }

    it_behaves_like "a forecast search prompt"

    it 'does not render the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", false)
    end
  end

  describe "GET /show" do
    subject(:make_request) { get '/forecast' }

    it_behaves_like "a forecast search prompt"

    it 'does not render the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", false)
    end
  end

  describe "GET /show/:zip", vcr: { cassette_name: "forecast/show_zip" }  do
    subject(:make_request) { get "/forecast/?zip=#{zip}&commit=Search" }
    let(:zip) { "96754" }

    it_behaves_like "a forecast search prompt"

    it 'renders the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", /.+/)
    end
  end
end
