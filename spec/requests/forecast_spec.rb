require 'rails_helper'

RSpec.describe "Forecast", type: :request do
  RSpec.shared_examples "a forecast search prompt" do |options|
    it 'renders the show template' do
      make_request
      follow_redirect! if options[:follow_redirect]
      expect(response).to render_template(:show)
    end

    it 'renders the search input' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='forecast-search-input']")
    end
  end

  describe "GET /" do
    subject(:make_request) { get '/' }

    it_behaves_like "a forecast search prompt", {}

    it 'does not render the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", false)
    end
  end

  describe "GET /show" do
    subject(:make_request) { get '/forecast' }

    it_behaves_like "a forecast search prompt", {}

    it 'does not render the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", false)
    end
  end

  describe "GET /show/:zip", vcr: { cassette_name: "forecast/show_zip" }  do
    subject(:make_request) { get "/forecast/?zip=#{zip}&commit=Search" }
    let(:zip) { "96754" }

    it_behaves_like "a forecast search prompt", {}

    it 'renders the current temp' do
      make_request
      assert_select("[data-testid='current-temp']", /.+/)
    end

    it 'does not render errors' do
      make_request
      assert_select("[data-testid='errors']", false)
    end
  end

  describe "GET /show/:zip invalid", vcr: { cassette_name: "forecast/show_zip_invalid" }  do
    subject(:make_request) { get "/forecast/?zip=#{zip}&commit=Search" }
    let(:zip) { "invalid" }

    it_behaves_like "a forecast search prompt", follow_redirect: true

    it 'does not render the current temp' do
      make_request
      expect(response).to redirect_to("/forecast")
      follow_redirect!
      assert_select("[data-testid='current-temp']", false)
    end

    it 'renders the errors' do
      make_request
      expect(response).to redirect_to("/forecast")
      follow_redirect!
      assert_select("[data-testid='errors']", /.+/)
    end
  end
end
