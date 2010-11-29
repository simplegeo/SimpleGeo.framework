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
