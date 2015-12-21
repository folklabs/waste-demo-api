json.set! '@id', "#{request.base_url}/tasks/#{task.id}"
# TODO: handle different task types
json.set! '@type', 'EmptyBinTask'
json.(task, :name, :scheduled_time, :start_time)
json.location do
  json.set! 'uprn', task.location.uprn
end
json.set! 'status', task.status

if params.has_key?('show_events')
  json.events task.events do |event|
    json.partial! 'events/_event', event: event
  end
end
