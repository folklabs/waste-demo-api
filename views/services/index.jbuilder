# json.member do
  json.array!(@services) do |service|
    json.partial! 'service', service: service
#  json.extract! service, :id, :name, :frequency, :esd_id, :organization
#  json.url api_service_url(service)
  end
# end
