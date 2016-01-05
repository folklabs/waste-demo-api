json.set! '@id', "#{request.base_url}/services/#{service['id']}"
json.set! '@type', 'WasteService'
json.set! 'name', service.name
json.(service, 'name', 'esd_url')#, :frequency, :description)

json.feature_types service.feature_types do |feature_type|
  # json.(feature_type, :name, :shape, :color, :lid_color, :description)
  json.(feature_type, :name, :description)
  # json.materials feature_type.material_streams do |material|
  #   # json.set! '@type', 'Material'
  #   json.(material, :name, :color)
  #   json.set! '@id', "#{request.base_url}/materials/#{material.id}"
  # end
end
# json.provider service.organization, :id, :name

# See if service is filtered to a UPRN
if params['uprn']
  json.set! 'uprn', params['uprn']

  json.last_collections filter_last_collections(@tasks, service) do |coll|
    json.partial! 'tasks/_task', task: coll
  end

  json.next_collections filter_next_collections(@tasks, service) do |coll|
    json.partial! 'tasks/_task', task: coll
  end
end

# json.provider do
#   json.set! '@id', "#{request.base_url}/organizations/#{service.organization.id}"
#   json.set! '@type', 'organizationization'
#   json.(service.organization, :name)
#   json.(service.organization.odc_resource, :email, :telephone)
#   json.set! 'url', service.organization.odc_resource.home_page.to_s
# end

