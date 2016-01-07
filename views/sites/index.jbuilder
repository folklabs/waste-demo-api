json.array!(@sites) do |site|
  json.partial! 'sites/_site', site: site
end
