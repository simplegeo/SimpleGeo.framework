require 'sinatra/base'
require 'oauth'
require 'oauth/request_proxy/rack_request'

class RackOAuthProvider < Sinatra::Base
  error 404 do
    @app.call(env)
  end

  before do
    halt 401 unless env['HTTP_AUTHORIZATION'] &&
        OAuth::Signature.verify(request) do |token, consumer_key|
      [nil, "consumerSecret"] if consumer_key == "consumerKey"
    end
  end
end
