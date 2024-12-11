class ForecastController < ApplicationController
  # GET the weather page
  # If a zip parameter exists, fetch the weather
  #
  def show
    @weather = nil
    if params[:zip]
      @zip = params[:zip]
      @from_cache = Rails.cache.exist?(cache_key)
      data = fetch_data
      @weather = WeatherPresenter.new(data)
    end
  rescue OpenWeather::Errors::Fault, Faraday::Error => exception
    flash[:alert] = exception.message || "Unknown error"
    redirect_to "/forecast"
  end

  private

  # Warn: changing the prefix will expire the cache for everyone
  #
  def cache_key
    "v1/US-zip/#@zip"
  end

  # Fetch the forecast data from the cache if it exists
  # or from the weather service
  #
  def fetch_data
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      weather_service.today(zip: @zip.to_i)
    end
  end

  def weather_service
    @weather_service ||= WeatherService.new
  end
end
