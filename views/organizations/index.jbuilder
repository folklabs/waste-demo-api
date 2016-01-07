# json.member do
  json.array!(@organizations) do |organization|
    json.partial! 'organization', organization: organization
#  json.extract! organization, :id, :name, :frequency, :esd_id, :organization
#  json.url api_organization_url(organization)
  end
# end
