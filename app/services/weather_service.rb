class WeatherService
  def initialize
    @client = OpenWeather::Client.new(api_key: ENV["API_KEY"])
  end

  # Fetches today's weather using the OpenWeather API
  #
  # ws = WeatherService.new
  # ws.today(zip: 94607)
  #
  def today(zip:)
    @client.current_weather(zip: zip, units: "imperial")&.main
  end
end
