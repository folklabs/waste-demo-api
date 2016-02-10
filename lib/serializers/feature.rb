class FeatureSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/features/#{item.id}"
    type "WasteContainer"

    map_properties :id, :name, :uprn

    property :site, "#{context[:request].base_url}/sites/#{item.uprn}"
  end

end
