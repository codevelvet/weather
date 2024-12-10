class ForecastController < ApplicationController
  def show
    @weather = nil
    if params[:zip]
      data = weather_service.today(zip: params[:zip].to_i)
      @weather = WeatherPresenter.new(data)
    end
  end

  private

  def weather_service
    @weather_service ||= WeatherService.new
  end
end
