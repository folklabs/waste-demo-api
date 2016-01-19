json.array!(@event_types) do |event_type|
  json.partial! 'event_types/_event_type', event_type: event_type
end
