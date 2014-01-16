require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>LULZMOVIESEARCH</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!
  response = Typhoeus.get("http://omdbapi.com", :params => {:s => "#{search_str}"})
  parsed = JSON.parse(response.body) #.body returns JSON string and turns it into Ruby hash
  listing = parsed['Search'].map {|movie| "<a href=/poster/#{movie['imdbID']}'#{movie['Title']} (#{movie['Year']})</a>"}
  #can't get list to work above
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results, Derp!</h1>\n<ul>"
  html_str += listing.join
  html_str += "</ul></body></html>"
end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.
  poster_call = Typhoeus.get("http://omdbapi.com", :params => {:i => imdb_id})
  parsed = JSON.parse(poster_call.body)
  listing = parsed['Search'].map {|thing| "#{thing['Poster']}"}

  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3>#{imdb_id}</h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

