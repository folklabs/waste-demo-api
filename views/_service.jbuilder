json.set! '@id', "#{request.base_url}/waste/services/#{service.id}"
json.set! '@type', 'WasteService'
json.(service, :name, :frequency, :description, :esd_url)
# json.geo do
#   json.(event, :lat, :long)
# end
# json.round "#{request.base_url}/waste/rounds/#{event.round}"
