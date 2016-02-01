class FeatureSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/features/#{item.id}"
    type "WasteContainer"

    map_properties :id, :name
  end

end
