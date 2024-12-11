require 'spec_helper'

RSpec.describe WeatherService do
  subject(:service) { described_class.new }

  describe '#today' do
    it 'returns weather today for zip',
      vcr: { cassette_name: 'weather_service/today ' } do
      data = service.today(zip: 96754)
      expect(data).to be_a Hash
      expect(data.name).to eq 'Kilauea'
      expect(data.main.temp).to be_a Numeric
      expect(data.main.temp_min).to be_a Numeric
      expect(data.main.temp_max).to be_a Numeric
    end

    it 'raises an error for an invalid zip code',
      vcr: { cassette_name: 'weather_service/today_invalid_zip ' } do
      expect { service.today(zip: 000) }
        .to raise_error(OpenWeather::Errors::Fault)
    end
  end
end
