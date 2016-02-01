class FeatureTypeSerializer < Oat::Serializer

  schema do
    link :self, href: "#{context[:request].base_url}/feature-types/#{item.id}"
    if item.category_name == "WASTE CONTAINER"
      type "WasteContainerType"
    else
      type "FeatureType"
    end

    map_properties :id, :name
  end

end
