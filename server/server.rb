require 'json'
require 'sinatra'
require 'digest/sha1'
require File.dirname(__FILE__) + '/examples'
require File.dirname(__FILE__) + '/lib/rack_oauth_provider'

use RackOAuthProvider

get '/1.0/features/:id.json' do
  case params[:id]
  when /^SG_4CsrE4oNy1gl8hCLdwu0F0/
    BURGER_MASTER
  when /^SG_0Bw22I6fWoxnZ4GDc8YlXd/
    CASTRO
  else
    404
  end
end

get '/1.0/places/:lat,:lon.json' do
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

post '/1.0/features/:id.json' do
  # Update a record
  # Requires a partial (or full) GeoJSON object, any fields you set in it
  # replace the fields of the record with the matching ID.
  # Returns a status polling token

  input = JSON.parse(env['rack.input'].read)

  if env['CONTENT_TYPE'] == 'application/json' && input['properties']
    [202, {'Content-Type' => 'application/json'}, '{"token": "79ea18ccfc2911dfa39058b035fcf1e5"}']
  else
    500
  end
end

delete '/1.0/features/:id.json' do
  # Delete a record.
  # Requires a single SimpleGeo ID
  # Returns a status polling token

  [202, {'Content-Type' => 'application/json'}, '{"token": "8fa0d1c4fc2911dfa39058b035fcf1e5"}']
end

post '/1.0/places' do
  # Create a new record, returns a 301 to the location of the resource.
  # Requires a GeoJSON object
  # Returns a JSON blob : {'id': 'record_id', 'uri': 'uri_of_record', 'token':
  # 'status_polling_token'}

  input = JSON.parse(env['rack.input'].read)
  coordinates = input['geometry']['coordinates']

  hash = Digest::SHA1.hexdigest("com.simplegeo#{input['id']}")
  handle = "SG_#{hash}_#{coordinates[1]}_#{coordinates[0]}@#{Time.now.to_i}"

  if env['CONTENT_TYPE'] == 'application/json' && input['properties']
    [301, {
      'Content-Type' => 'application/json',
      'Location' => "#{env['rack.url_scheme']}://#{env['SERVER_NAME']}:#{env['SERVER_PORT']}/1.0/features/#{handle}.json"
     },
     "{\"token\": \"596499b4fc2a11dfa39058b035fcf1e5\", \"id\": \"#{handle}\", \"uri\": \"/1.0/features/#{handle}.json\"}"]
  else
    500
  end
end

get '/1.0/context/:lat,:lon.json' do
  # sample response for /1.0/context/37.803259,-122.440033.json
  CONTEXT
end
