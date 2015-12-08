# json.member do
  json.array!(@sites) do |site|
    json.partial! 'sites/_site', site: site
#  json.extract! site, :id, :name, :frequency, :esd_id, :organization
#  json.url api_site_url(site)
  end
# end
