json.set! '@id', "#{request.base_url}/api/services/#{service.id}"
json.set! '@type', 'WasteService'
json.set! 'name', service['name']
json.(service, 'name')#, :frequency, :description)
# json.esd_url "http://id.esd.org.uk/service/#{service.esd_id}"

json.container_types service.container_types do |container_type|
  # json.(container_type, :name, :shape, :color, :lid_color, :description)
  json.(container_type, :name, :description)
  # json.materials container_type.material_streams do |material|
  #   # json.set! '@type', 'Material'
  #   json.(material, :name, :color)
  #   json.set! '@id', "#{request.base_url}/api/materials/#{material.id}"
  # end
end
# json.provider service.organization, :id, :name

# See if service is filtered to a UPRN
if params['uprn']
  json.set! 'uprn', params['uprn']
  json.last_collections last_collections(params['uprn'], service) do |coll|
    json.partial! 'tasks/_task', task: coll
  end
  json.next_collections next_collections(params['uprn'], service) do |coll|
    json.partial! 'tasks/_task', task: coll
  end
end

# json.provider do
#   json.set! '@id', "#{request.base_url}/api/organizations/#{service.organization.id}"
#   json.set! '@type', 'organizationization'
#   json.(service.organization, :name)
#   json.(service.organization.odc_resource, :email, :telephone)
#   json.set! 'url', service.organization.odc_resource.home_page.to_s
# end

