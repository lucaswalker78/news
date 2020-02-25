require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "48ed658e2cf569e734d88a6cd85bf408"

# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=30c0f09f76394df2ab7b6f4247a47304"
news = HTTParty.get(url).parsed_response.to_hash

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates
    "#{lat_long[0]} #{lat_long[1]}"
    forecast = ForecastIO.forecast("#{lat_long[0]}","#{lat_long[1]}").to_hash
    @current_summary =  forecast ["currently"]["summary"]
    @current_temp = forecast ["currently"]["temperature"]
    @forecast_array = forecast["daily"]["data"]
    for the_weather_today in @forecast_array
    puts "#{the_weather_today["temperatureLow"]}" and "#{the_weather_today["summary"]}"
    end
    # news is now a Hash you can pretty print (pp) and parse for your output
    pp news
    @news_title = news["articles"][0]["title"]
    @news_url = news["articles"][0]["url"]
    view "news"
end