json.set! '@id', "#{request.base_url}/feature_types/#{feature_type.id}"

if feature_type.category_name == "WASTE CONTAINER"
  json.set! '@type', 'WasteContainerType'
else
  json.set! '@type', 'FeatureType'
end

json.(feature_type, :id, :name)
