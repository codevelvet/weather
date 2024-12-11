require 'rails_helper'

RSpec.describe "Forecast", type: :request do
  RSpec.shared_examples "a forecast search prompt" do |options = {}|
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

  RSpec.shared_examples "a response without forecast data" do |options = {}|
    it 'does not render the forecast data' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='forecast-data']", false)
    end
  end

  RSpec.shared_examples "a response with forecast data" do |options = {}|
    it 'renders the forecast data' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='forecast-data']")
    end

    it 'renders the current temp' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='current-temp']", /.+/)
    end

    it 'renders the max temp' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='max-temp']", /.+/)
    end

    it 'renders the min temp' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='min-temp']", /.+/)
    end

    it 'does not render errors' do
      make_request
      follow_redirect! if options[:follow_redirect]
      assert_select("[data-testid='errors']", false)
    end
  end

  describe "GET /" do
    subject(:make_request) { get '/' }

    it_behaves_like "a forecast search prompt"
    it_behaves_like "a response without forecast data"
  end

  describe "GET /show" do
    subject(:make_request) { get '/forecast' }

    it_behaves_like "a forecast search prompt"
    it_behaves_like "a response without forecast data"
  end

  describe "GET /show/:zip", vcr: { cassette_name: "forecast/show_zip" }  do
    subject(:make_request) { get "/forecast/?zip=#{zip}&commit=Search" }
    let(:zip) { "96754" }

    it_behaves_like "a forecast search prompt"
    it_behaves_like "a response with forecast data"
  end

  describe "GET /show/:zip invalid", vcr: { cassette_name: "forecast/show_zip_invalid" }  do
    subject(:make_request) { get "/forecast/?zip=#{zip}&commit=Search" }
    let(:zip) { "invalid" }

    it_behaves_like "a forecast search prompt", follow_redirect: true
    it_behaves_like "a response without forecast data", follow_redirect: true

    it 'renders the errors' do
      make_request
      expect(response).to redirect_to("/forecast")
      follow_redirect!
      assert_select("[data-testid='errors']", /.+/)
    end
  end
end
