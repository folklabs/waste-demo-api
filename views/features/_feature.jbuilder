json.set! '@id', "#{request.base_url}/features/#{feature.id}"
json.set! '@type', 'WasteContainer'
json.(feature, :id, :name)
