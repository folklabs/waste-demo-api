json.array!(@feature_types) do |feature_type|
  json.partial! 'feature_types/_feature_type', feature_type: feature_type
end
