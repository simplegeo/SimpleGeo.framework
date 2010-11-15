require 'json'
require 'sinatra'

get '/0.1/features/:id.json' do
  {
    :foo => "bar",
  }.to_json
end
