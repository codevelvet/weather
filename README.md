# Weather App: A simple Rails app to fetch today's forecast.
Given a zip code, this version fetches today's weather forecast including:
 * current temp
 * high temp
 * low temp

## Quick Start
This app was developed using:
 - ruby 3.3.6
 - Rails 7.2

 No database is needed.

 Checkout the source, then add your [OpenWeather API Key](https://openweathermap.org/api) to the new files in the project root:
  - `.env.development.local`
  - `.env.test.local`

 ```
 WEATHER_API_KEY=your-key-goes-here
 ```

Install the required gems:

```
bundle install
```

 Start the Rails server locally with:

 ```
  ./bin/rails server
```

 ### OpenWeather API
 You will need an OpenWeather API key. This is FREE for the current useage.
 See https://openweathermap.org/api

## Testing
This app uses rspec for testing. To run the tests:

```
bundle exec rspec
 ```

## Caching
This app caches the weather by zip code for 30 minutes.
To toggle caching in your dev environment:

```
bundle exec rails dev:cache
```

## UI
Bootstrap is being used for layout and styling.
Responsive Design is baked in.

## Scaling considerations
Since uses a 3rd party API, including a rate limiter to avoid unexpected lockout for everyone is prudent.  Some options include using the rack_attack gem or if on Rails 7.2+ use the baked in rate limiter.

### Load balancer
Setup and monitor a load balancer to distribute traffic across multiple servers.

### Horizontal scaling
Adding new servers is made easy by AWS, Google Cloud, etc.
Also consider auto scaling.

### CDN
Serve static assets and cached data to reduce the load on the servers and improve page load speed. Services such as Cloudflare can be setup to do this.

### Observability
Observability metrics should be added for on call support including the following:
 - A canary alert that hits the 3rd party API once every X minutes and alerts if it does not respond within Y tries
- Sending error counts to alert on if they exceed a threshold
- Monitor response times to ensure performance is acceptable

Tools such as Datadog can be used for observability.

### Database
This app does not use a database, but if one is in play, make sure indexes are setup and being used to perform queries.  Consider replicating data to multiple database servers to distribute load.
