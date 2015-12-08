# show_events = false if 
json.set! '@id', "#{request.base_url}/api/tasks/#{task.id}"
# TODO: handle different task types
json.set! '@type', 'EmptyBinTask'
# json.(task, :name, :scheduled_time, :start_time)
# json.set! 'uprn', params['uprn']
json.set! 'status', task.status

# if defined?(params['show_events'])
#   json.events task.events do |event|
#     json.partial! 'api/events/event', event: event
#   end
# end
