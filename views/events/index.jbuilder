json.array!(@events) do |event|
  json.partial! 'events/_event', event: event
end
