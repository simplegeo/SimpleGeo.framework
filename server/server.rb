require 'json'
require 'sinatra'
require File.dirname(__FILE__) + '/examples'
require File.dirname(__FILE__) + '/lib/rack_oauth_provider'

use RackOAuthProvider

get '/0.1/features/:id.json' do
  case params[:id]
  when /^SG_4CsrE4oNy1gl8hCLdwu0F0/
    BURGER_MASTER
  else
    404
  end
end

get '/0.1/places/:lat,:lon/search.json' do
  case params[:q]
  when "zero"
    <<-EOS
{
    "total": 0,
    "type": "FeatureCollection",
    "features": []
}
    EOS
  when "one"
    <<-EOS
{
    "total": 1, 
    "type": "FeatureCollection", 
    "features": [
#{BURGER_MASTER}
    ]
}
    EOS
  else
    BURGERS
  end
end

post '/0.1/places/:id.json' do
  # Update a record
  # Requires a partial (or full) GeoJSON object, any fields you set in it
  # replace the fields of the record with the matching ID.
  # Returns a status polling token

  # TODO verify input content-type
  # TODO verify input and throw some sort of error if it's off

  [202, {'Content-Type' => 'application/json'}, "{'token': '79ea18ccfc2911dfa39058b035fcf1e5'}"]
end

delete '/0.1/places/:id.json' do
  # Delete a record.
  # Requires a single SimpleGeo ID
  # Returns a status polling token

  # TODO verify input content-type
  # TODO verify input and throw some sort of error if it's off

  [202, {'Content-Type' => 'application/json'}, "{'token': '8fa0d1c4fc2911dfa39058b035fcf1e5'}"]
end

put '/0.1/places/place.json' do
  # Create a new record, returns a 301 to the location of the resource.
  # Requires a GeoJSON object
  # Returns a JSON blob : {'id': 'record_id', 'uri': 'uri_of_record', 'token':
  # 'status_polling_token'}

  # TODO verify input content-type
  # TODO verify input and throw some sort of error if it's off
  # TODO pull the id from the input and generate a hash
  hash = "something"

  [202, {'Content-Type' => 'application/json'},
   "{'token': '596499b4fc2a11dfa39058b035fcf1e5', 'id': #{hash}, 'uri': '/1.0/places/#{hash}.json'}"]
  
end

get '/0.1/context/:lat,:lon.json' do
  # sample response for /0.1/context/37.803259,-122.440033.json
  <<-EOS
{"weather":{"temperature":"65F","conditions":"light
haze"},"features":[{"category": "Neighborhood", "source":
"factle.com", "subcategory": "", "bounds": [-122.451382,
37.798727999999997, -122.42438199999999, 37.808627999999999], "type":
"Boundary", "id": "SG_72BK8PRtgDlA7tg4jCgvV5_37.803147_-122.438762",
"abbr": "", "name": "Marina"}],"demographics":{"metro_score":"9"}}
  EOS
end
