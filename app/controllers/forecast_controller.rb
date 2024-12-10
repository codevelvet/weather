class ForecastController < ApplicationController
  def show
    @presenter = nil
    if params[:zip]
      weather = weather_service.today(zip: params[:zip].to_i)
      Rails.logger.info(weather)
      @presenter = WeatherPresenter.new(weather)
    end
  end

  private

  def weather_service
    @weather_service ||= WeatherService.new
  end
end
