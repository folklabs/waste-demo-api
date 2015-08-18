json.set! '@id', "#{request.base_url}/waste/events/#{event.id}"
json.set! '@type', 'WasteEvent'
json.(event, :type, :start_date, :uprn)
json.geo do
  json.(event, :lat, :long)
end
json.round "#{request.base_url}/waste/rounds/#{event.round}"
