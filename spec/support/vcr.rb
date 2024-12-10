require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('WEATHER_API_KEY') { ENV['WEATHER_API_KEY'] }
  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:appid)
    ]
  }
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end
