require 'json'
require 'sinatra'

get '/0.1/features/:id.json' do
  {
    "type" => "Feature",
    "geometry" => {
      "type" => "Point",
      "coordinates" => [
        -122.938,
        37.079
      ]
    },
    "properties" => {
        "type" => "place"
    }
  }.to_json
end
