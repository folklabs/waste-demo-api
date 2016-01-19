json.array!(@features) do |feature|
  json.partial! 'features/_feature', feature: feature
end
