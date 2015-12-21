json.set! '@id', "#{request.base_url}/events/#{event.id}"
json.set! '@type', 'WasteEvent'
json.(event, :id, :event_type, :start_date, :task_id)
json.location do
  json.partial! 'sites/sites', place: event.location
  # json.(event.location, :uprn)
  # json.geo do
  #   json.(event.location, :latitude, :longitude)
  # end
end
