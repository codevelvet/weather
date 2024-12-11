class WeatherPresenter
  # Using a simple presenter design pattern
  # Wraps the OpenWeather API response data for presentation
  def initialize(data)
    @data = data
  end

  def current_temp
    @data&.main&.temp
  end

  def max_temp
    @data&.main&.temp_max
  end

  def min_temp
    @data&.main&.temp_min
  end
end
