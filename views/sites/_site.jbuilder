json.set! '@id', "#{request.base_url}/api/sites/#{site.uprn}"
json.set! '@type', 'site'
json.(@site, :uprn, :usrn)
json.geo do
  json.(site, :latitude, :longitude)
end
if site.address
  json.address do
    json.(site.address, :paon, :saon, :street, :locality, :town, :postcode, :description)
  end
end
