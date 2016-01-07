json.set! '@id', "#{request.base_url}/event_types/#{event_type.id}"
json.set! '@type', 'EventType'
json.(event_type, :id, :name)
if event_type.parent
json.parent do
  json.partial! 'event_types/_event_type', event_type: event_type.parent
end
