# json.set! '@id', "#{request.base_url}/organizations/#{organization.id}"
json.set! '@type', 'Organization'
json.(organization, :name, :opendatacommunities_url)
# json.geo do
#   json.(place, :latitude, :longitude)
# end
# json.round "#{request.base_url}/waste/rounds/#{event.round}"

# json.container_types service.container_types do |container_type|
#   json.(container_type, :shape, :size, :color, :lid_color, :description)
#   json.material_streams container_type.material_streams do |stream|
#     json.(stream, :name)
#   end
# end
json.email organization.odc_resource.email
json.telephone organization.odc_resource.telephone
json.contact_page organization.odc_resource.contact_page.to_s
json.home_page organization.odc_resource.home_page.to_s
json.address organization.odc_resource.address.locality
