class WeatherService
  # Weather Service fetches forecast information.
  #
  # Delegates to an OpenWeather::Client
  #
  # The service layer design pattern encapsulates core business logic
  # If this app included a database, the service layer would provide the
  # heavy lifting while the model layer would simply store the data.
  #
  def initialize
    @client = OpenWeather::Client.new(api_key: ENV["WEATHER_API_KEY"])
  end

  # Fetches today's weather using the OpenWeather API
  #
  # Returns a Hash of the data
  #
  # ws = WeatherService.new
  # ws.today(zip: 94607)
  #
  # Raises OpenWeather::Errors::Fault and Faraday errors
  #
  def today(zip:)
    @client.current_weather(zip: zip, units: "imperial")

  rescue OpenWeather::Errors::Fault => exception
    # Enter observability metric here for oncall support
    Rails.logger.error("WeatherService - today error: #{exception.message}")
    raise
  end
end
