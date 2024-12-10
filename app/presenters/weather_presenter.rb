class WeatherPresenter
  def initialize(data)
    @data = data
  end

  def current_temp
    @data&.temp
  end

  def max_temp
    @data&.temp_max
  end

  def min_temp
    @data&.temp_min
  end
end
