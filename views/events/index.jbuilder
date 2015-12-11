# json.member do
  json.array!(@events) do |event|
    json.partial! 'events/_event', event: event
#  json.extract! event, :id, :name, :frequency, :esd_id, :organization
#  json.url api_event_url(event)
  end
# end
