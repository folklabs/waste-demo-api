
json.array! @services do |service|
  json.partial! 'service', service: service
end
