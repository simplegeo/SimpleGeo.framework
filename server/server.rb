require 'json'
require 'sinatra'

SG_BOULDER = <<-EOS
{
  "id": "SG_qwerty",
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      -105.27739,
      40.01705
    ]
  },
  "properties": {
    "name": "SimpleGeo Boulder",
    "address": "1360 Walnut St. Suite 110",
    "city": "Boulder",
    "province": "CO",
    "postcode": "80302",
    "type": "Business",
    "categories": [
      "Internet"
    ]
  }
}
EOS

SG_SF = <<-EOS
{
  "id": "SG_asdf",
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      -122.40593,
      37.77241
    ]
  },
  "properties": {
    "name": "SimpleGeo San Francisco",
    "address": "41 Decatur St.",
    "city": "San Francisco",
    "province": "CA",
    "postcode": "94102",
    "type": "Business",
    "categories": [
      "Internet"
    ]
  }
}
EOS

get '/0.1/features/:id.json' do
  SG_SF
end

get '/0.1/places/:lat,:lon/search.json' do
  if params[:q] == 'one'
    <<-EOS
    [
#{SG_BOULDER}
    ]
    EOS
  else
    <<-EOS
    [
#{SG_BOULDER},
#{SG_SF}
    ]
    EOS
  end
end
