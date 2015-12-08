json.set! '@id', "#{request.base_url}/api/services/#{service.id}"
json.set! '@type', 'WasteService'
json.(service, :name, :frequency, :description)
json.esd_url "http://id.esd.org.uk/service/#{service.esd_id}"
# json.geo do
#   json.(event, :lat, :long)
# end
# json.round "#{request.base_url}/waste/rounds/#{event.round}"

json.container_types service.container_types do |container_type|
  json.(container_type, :name, :shape, :color, :lid_color, :description)
  json.materials container_type.material_streams do |material|
    # json.set! '@type', 'Material'
    json.(material, :name, :color)
    json.set! '@id', "#{request.base_url}/api/materials/#{material.id}"
  end
end
# json.provider service.organization, :id, :name

# See if service is filtered to a UPRN
if params['uprn']
  json.set! 'uprn', params['uprn']
  json.last_collections service.last_collections(params['uprn']) do |coll|
    json.partial! 'api/tasks/task', task: coll
  end
  # json.next_collections service.next_collections(params['uprn']) do |coll|
  #   json.partial! 'api/tasks/task', task: coll
  # end
end

json.provider do
  json.set! '@id', "#{request.base_url}/api/organizations/#{service.organization.id}"
  json.set! '@type', 'Organization'
  json.(service.organization, :name)
  json.(service.organization.odc_resource, :email, :telephone)
  json.set! 'url', service.organization.odc_resource.home_page.to_s
end

# if service.round_plans.any?
#   round = service.last_collection_round
#   json.last_collection do
#     json.date round.date.xmlschema
#     json.set! 'round', "#{request.base_url}/api/rounds/#{service.last_collection_round.id}"
#     # json.set! '@type', 'WasteCollection'
#     json.events round.events do |event|
#       json.set! 'type', event.event_type
#       json.(event, :uprn, :image)
#     end
#   end
#   json.next_collection do
#     json.date service.next_collection
#     # json.set! '@type', 'WasteCollection'
#   end
# end
