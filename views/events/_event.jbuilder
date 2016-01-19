json.set! '@id', "#{request.base_url}/events/#{event.id}"
json.set! '@type', 'WasteEvent'
json.(event, :id, :event_type, :start_date)
json.set! 'task', "#{request.base_url}/tasks/#{event.task_id}" if event.task_id
json.location do
  json.partial! 'sites/_site', site: event.location
end
